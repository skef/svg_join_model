function jsa = ArcsJoin(jp)
  if (jp.cu1!=0)
    r1 = abs(1/jp.cu1);
    cv1 = sign(jp.cu1) * Rotate90CCW(jp.tv1);
    c1 = jp.p1 + cv1 * r1;
  endif
  if (jp.cu2!=0)
    r2 = abs(1/jp.cu2);
    cv2 = sign(jp.cu2) * Rotate90CCW(jp.tv2);
    c2 = jp.p2 + cv2 * r2;
  endif
  jl = CalcJoinLength(jp);

  if ((jp.cu1==0 && jp.cu2==0) || isinf(jl))
      "Both points have no curvature or tangents are parallel -- falling back to miterclip"
      jsa = MiterJoin(jp);
      return;
  endif

  max_jl = MaxJoinLength(jp);

  if (jp.cu1==0)
    cnt = LineCircleTest(jp.p1, jp.tv1, c2, r2);
    if (cnt>0)
      [i1, i2] = IntersectLineCircle(jp.p1, jp.tv1, c2, r2);
    endif
  elseif (jp.cu2==0)
    cnt = LineCircleTest(jp.p2, jp.tv2, c1, r1);
    if (cnt>0)
      [i1, i2] = IntersectLineCircle(jp.p2, jp.tv2, c1, r1);
    endif
  else
    [cnt, note] = CirclesTest(c1, r1, c2, r2);
    if (cnt>0)
      [i1, i2] = IntersectCircles(c1, r1, c2, r2);
    else
#      jsa{1} = [c1(1), c1(2), r1, 0, 360];
#      jsa{2} = [c2(1), c2(2), r2, 0, 360];
#      return;
      if (note==-2)
        [r2, r1] = AdjustCircles(jp.p2, cv2, r2, jp.p1, cv1, r1, 1);
      else
        [r1, r2] = AdjustCircles(jp.p1, cv1, r1, jp.p2, cv2, r2, note<0);
      endif
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

  [jlc, jlr] = PVPCircle(jp.ojp, (jp.tv1-jp.tv2)/2, i);

  if (max_jl < norm(jp.ojp-i)*pi/2) # Conservative check
    max_theta = max_jl/jlr;
  endif

  if (jp.cu1!=0)
    if (jp.cu1>0)
      ext1 = rad2deg(vectorAngle(jp.p1-c1, i-c1));
    else
      ext1 = -rad2deg(vectorAngle(i-c1, jp.p1-c1));
    endif
    jsa = {[c1(1), c1(2), r1, rad2deg(vectorAngle(jp.p1-c1)), ext1]};
  else
    jsa = {[jp.p1, i]};
  endif
  if (jp.cu2!=0)
    if (jp.cu2>0)
      ext2 = rad2deg(vectorAngle(i-c2, jp.p2-c2));
    else
      ext2 = -rad2deg(vectorAngle(jp.p2-c2, i-c2));
    endif
    jsa{2} = [c2(1), c2(2), r2, rad2deg(vectorAngle(i-c2)), ext2];
  else
    jsa{2} = [i, jp.p2];
  endif

#  jsa{3} = [jlc(1), jlc(2), jlr, 0, 360];
endfunction
