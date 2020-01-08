function s = JoinBendSign(tv1, tv2)
  cp = Cross2D(tv1, tv2);
  if (abs(cp)<1e-8)
    cp = 0;
  endif
  s = sign(cp);
endfunction
