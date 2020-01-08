function jsa = RoundJoin(jp)
  v1 = jp.p1-jp.ojp;
  v2 = jp.p2-jp.ojp;
  sa = rad2deg(vectorAngle(v1))
  ad = rad2deg(vectorAngle(v1, v2))
  if (ad>180)
    ad = ad-360;
  endif
  jsa = {[jp.ojp(1), jp.ojp(2), jp.sw/2, sa, ad]}
endfunction
