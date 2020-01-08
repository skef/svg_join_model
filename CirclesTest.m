function [cnt, note] = CirclesTest(c1, r1, c2, r2)
  c_dist = norm(c1-c2);
  note = 0;
  cnt = 2;
  if (abs(c_dist - r1 - r2) < 1e-2)
    cnt = 1;
  elseif (c_dist > r1 + r2)
    cnt = 0;
    note = 1;
  elseif (c_dist < abs(r1 - r2))
    cnt = 0;
    if (r1 > r2)
      note = -1;
    else
      note = -2;
    endif
  endif
endfunction
