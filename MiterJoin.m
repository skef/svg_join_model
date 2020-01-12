function jsa = MiterJoin(jp)
  max_jl = MaxJoinLength(jp);
  jl = CalcJoinLength(jp);

  if (jl<=max_jl)
    i = IntersectLines(jp.p1, jp.tv1, jp.p2, jp.tv2);
    jsa = {{jp.p1, i}, {i, jp.p2}};
    return;
  elseif (strcmp(jp.join,'miter'))
    jsa = {{jp.p1, jp.p2}};
    return;
  endif
  clut = normalizeVector(jp.p2-jp.p1);
  # Note how the join_bend_sign is used to calculate the "outward" direction
  clp = jp.ojp - jp.jbs * Rotate90CCW(clut) * max_jl/2;
  if (!LineSameSide(jp.p1, jp.p2, clp, jp.p1+jp.tv1))
    jsa = {{jp.p1, jp.p2}};
  else
    i1 = IntersectLines(jp.p1, jp.tv1, clp, clut);
    i2 = IntersectLines(jp.p2, jp.tv2, clp, clut);
    jsa = {{jp.p1, i1}, {i1, i2}, {i2, jp.p2}};
  endif
endfunction
