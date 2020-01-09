function [r1n, r2n] = AdjustCircles(p1, v1, r1, p2, v2, r2, inside)
  if (inside)
    fac = -1;
  else
    fac = 1;
  endif
  A = p1 - p2 + r1*v1 - r2*v2;
  B = fac*v1 - v2;
  C = r1 + fac*r2;
  D = fac*2;
  c = A(1)**2 + A(2)**2 - C**2;
  b = 2*(A(1)*B(1) + A(2)*B(2) - C*D);
  a = B(1)**2 + B(2)**2 - D**2;
  d = b**2 - 4*a*c;
  if (abs(d*a**2) < 1e-4)
    d = 0.0;
  endif
  d = sqrt(d);
  e = (-b + d)/(2*a);
  if (e < 0)
    e = (-b - d)/(2*a);
  endif
  r1n = r1+fac*e;
  r2n = r2+e;
endfunction
