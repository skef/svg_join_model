function jsa = ArcsJoin(jp)

  # Derive curvature parameters
  if (jp.cu1!=0)
    r1 = abs(1/jp.cu1);
    cv1 = sign(jp.cu1) * Rotate90CCW(jp.tv1);
    c1 = jp.p1 + cv1 * r1;
  else
    r1 = Inf;
  endif
  if (jp.cu2!=0)
    r2 = abs(1/jp.cu2);
    cv2 = sign(jp.cu2) * Rotate90CCW(jp.tv2);
    c2 = jp.p2 + cv2 * r2;
  else
    r2 = Inf;
  endif

  # Miter-clip fallbacks
  jl = CalcJoinLength(jp);

  if ((jp.cu1==0 && jp.cu2==0) || isinf(jl))
      "Both points have no curvature or tangent lines are parallel -- falling back to miterclip"
      jsa = MiterJoin(jp);
      return;
  endif

  max_jl = MaxJoinLength(jp);

  # Main arc/line calculations
  if (jp.cu1==0)
    cnt = LineCircleTest(jp.p1, jp.tv1, c2, r2);
    if (cnt>0)
      [i1, i2] = IntersectLineCircle(jp.p1, jp.tv1, c2, r2);
    else
      r2old = r2;
      r2 = AdjustLineCircle(jp.p1, jp.tv1, jp.p2, cv2);
      c2 = jp.p2 + cv2 * r2;
      cnt = 1;
      i1 = ProjectPointOnLine(c2, jp.p1, jp.tv1);
      warning("Increasing radius of curvature at second offset point from %f to %f", r2old, r2);
    endif
  elseif (jp.cu2==0)
    cnt = LineCircleTest(jp.p2, jp.tv2, c1, r1);
    if (cnt>0)
      [i1, i2] = IntersectLineCircle(jp.p2, jp.tv2, c1, r1);
    else
      r1old = r1;
      r1 = AdjustLineCircle(jp.p2, jp.tv2, jp.p1, cv1);
      c1 = jp.p1 + cv1 * r1;
      cnt = 1;
      i1 = ProjectPointOnLine(c1, jp.p2, jp.tv2);
      warning("Increasing radius of curvature at first offset point from %f to %f", r1old, r1);
    endif
  else
    [cnt, note] = CirclesTest(c1, r1, c2, r2);
    if (cnt>0)
      [i1, i2] = IntersectCircles(c1, r1, c2, r2);
    else
      r1old = r1;
      r2old = r2;
      if (note==-2)
        [r2, r1] = AdjustCircles(jp.p2, cv2, r2, jp.p1, cv1, r1, 1);
      else
        [r1, r2] = AdjustCircles(jp.p1, cv1, r1, jp.p2, cv2, r2, note<0);
      endif
      warning("Changing radii of curvatures: r1 from %f to %f, r2 from %f to %f", r1old, r1, r2old, r2);
      c1 = jp.p1 + cv1 * r1;
      c2 = jp.p2 + cv2 * r2;
      cnt = 1;
      if (note==-2)
        i1 = c2 + normalizeVector(c1-c2)*r2;
      else
        i1 = c1 + normalizeVector(c2-c1)*r1;
      endif
    endif
  endif

  # Round fallback
  if (r1 < jp.sw/2 || r2 < jp.sw/2)
      "At least one curvature is greater than 2/strokewidth -- falling back to round"
      jsa = RoundJoin(jp);
      return;
  endif

  if (cnt > 1)
    i = CloserIntersection(jp.p1, jp.p2, i1, i2, jp.p1+jp.tv1);
  else
    i = i1;
  endif

  # Unclipped arcs/Line segments
  if (jp.cu1!=0)
    seg1 = {c1, r1, normalizeVector(jp.p1-c1), normalizeVector(i-c1), sign(jp.cu1)};
  else
    seg1 = {jp.p1, i};
  endif
  if (jp.cu2!=0)
    seg2 = {c2, r2, normalizeVector(i-c2), normalizeVector(jp.p2-c2), sign(jp.cu2)};
  else
    seg2 = {i, jp.p2};
  endif

  # Calculate clipping line (if any)
  clipped = 0;
  clipv1 = (jp.tv1-jp.tv2)/2;
  clipv2 = i-jp.ojp;
  l_cv2 = norm(clipv2);
  clipv2 = normalizeVector(clipv2);
  if (abs(Cross2D(clipv1, clipv2)) < 1e-8)
    if (max_jl/2 < l_cv2)
       clipped = 1;
       crefp = jp.ojp + (max_jl/2) * clipv2;
       crefv = Rotate90CCW(clipv2);
    endif
  elseif ((max_jl/2) < l_cv2*pi/2) # Conservative check
    [jlc, jlr, jls] = PVPCircle(jp.ojp, (jp.tv1-jp.tv2)/2, i);
    max_angle_diff = (max_jl/2)/jlr;
    start_angle = vectorAngle(jp.ojp-jlc);
    end_angle = vectorAngle(i-jlc);
    if (jls < 0)
      angle_diff = normalizeAngle(end_angle - start_angle);
    else
      angle_diff = normalizeAngle(start_angle - end_angle);
    endif
    if (angle_diff > max_angle_diff)
      clipped = 1;
      if (jls < 0)
        max_angle = normalizeAngle(start_angle + max_angle_diff);
      else
        max_angle = normalizeAngle(start_angle - max_angle_diff);
      endif
      crefv = [cos(max_angle) sin(max_angle)];
      crefp = jlc + crefv*jlr;
    endif
  endif

  if (clipped)
    if (jp.cu1!=0)
      [ci1a, ci1b] = IntersectLineCircle(crefp, crefv, c1, r1);
      ci1 = CloserPoint(crefp, ci1a, ci1b);
      if (LineSameSide(jp.p1, jp.p2, ci1, jp.p1+jp.tv1))
        ca1 = {{c1, r1, seg1{3}, normalizeVector(ci1-c1), sign(jp.cu1)}};
      else
        ca1 = {};
	ci1 = jp.p1;
      endif
    else
      ci1 = IntersectLines(jp.p1, jp.tv1, crefp, crefv);
      if (LineSameSide(jp.p1, jp.p2, ci1, jp.p1+jp.tv1))
        ca1 = {{jp.p1, ci1}};
      else
        ca1 = {};
	ci1 = jp.p1;
      endif
    endif
    if (jp.cu2!=0)
      [ci2a, ci2b] = IntersectLineCircle(crefp, crefv, c2, r2);
      ci2 = CloserPoint(crefp, ci2a, ci2b);
      if (LineSameSide(jp.p1, jp.p2, ci2, jp.p1+jp.tv1))
        ca2 = {{c2, r2, normalizeVector(ci2-c2), seg2{4}, sign(jp.cu2)}};
      else
        ca2 = {};
	ci2 = jp.p2;
      endif
    else
      ci2 = IntersectLines(jp.p2, jp.tv2, crefp, crefv);
      if (LineSameSide(jp.p1, jp.p2, ci2, jp.p1+jp.tv1))
        ca2 = {{ci2, jp.p2}};
      else
        ca2 = {};
	ci2 = jp.p2;
      endif
    endif
    jsa = [ca1, {{ci1, ci2}}, ca2];
  else
    jsa = {seg1, seg2};
  endif

endfunction
