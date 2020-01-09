function jsa = RoundJoin(jp)
  v1 = jp.p1-jp.ojp;
  v2 = jp.p2-jp.ojp;
  sa = rad2deg(vectorAngle(v1));
  if (jp.jbs>0)
    ad = rad2deg(vectorAngle(v1, v2));
  else
    ad = -rad2deg(vectorAngle(v2, v1));
  endif
  jsa = {[jp.ojp(1), jp.ojp(2), jp.sw/2, sa, ad]};
endfunction
