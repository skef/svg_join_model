function jsa = RoundJoin(jp)
  jsa = {{jp.ojp, jp.sw/2, normalizeVector(jp.p1-jp.ojp), normalizeVector(jp.p2-jp.ojp), jp.jbs}};
endfunction
