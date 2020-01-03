function [cnt] = LineCircleTest(l1, l2, c1, r1)
  cl_dist = distancePointLine(c1, createLine(l1, l2));
  cnt = 2;
  if (abs(cl_dist-r1) < 1e-2)
    cnt = 1;
  elseif (cl_dist > r1)
    cnt = 0;
  endif
endfunction
