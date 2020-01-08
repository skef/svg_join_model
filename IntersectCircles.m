function [i1, i2] = IntersectCircles(c1, r1, c2, r2)
  c_dist = norm(c1-c2);
  t1 = .5*(r2**2 - r1**2)/c_dist**2 * (c1-c2) + .5*(c1+c2);
  tmp = 2 * (r2**2+r1**2)/c_dist**2 - (r2**2-r1**2)**2/c_dist**4 - 1;
  if (abs(tmp) > 1e-2)
    t2 = sqrt(tmp)/2 * [c1(2)-c2(2), c2(1)-c1(1)];
  else
    t2 = 0
  endif
  i1 = t1+t2;
  i2 = t1-t2;
endfunction
