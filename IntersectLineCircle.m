function [i1, i2] = IntersectLineCircle(l1, l2, c1, r1)
  swapped = 0;
  t = l2(2)-l1(2);
  u = l1(1)-l2(1);
  v = l2(1)*l1(2) - l1(1)*l2(2);
  if (abs(u) < 1e-4)
    swapped = 1;
    tmp = t;
    t = u;
    u = tmp;
    tmp = c1(1);
    c1(1) = c1(2);
    c1(2) = tmp;
  endif
  a = t**2 + u**2
  b = 2*t*v + 2*t*u*c1(2) - 2*u**2*c1(1)
  c = v**2 + 2*u*v*c1(2) - u**2*(r1**2 - c1(1)**2 - c1(2)**2);
  d = b**2 - 4*a*c
  if (abs(d*a**2) < 1e-4)
    d = 0.0;
  endif
  d = sqrt(d);
  if (swapped==1)
    r = (-b + d)/(2*a);
    i1 = [-(t * r + v)/u, r];
    r = (-b - d)/(2*a);
    i2 = [-(t * r + v)/u, r];
  else
    r = (-b + d)/(2*a);
    i1 = [r, -(t * r + v)/u];
    r = (-b - d)/(2*a);
    i2 = [r, -(t * r + v)/u];
  endif
endfunction
