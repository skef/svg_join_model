function r = AdjustLineCircle(l1, luv, p1, v1)
  D = Cross2D(luv, l1-p1);
  E = Cross2D(v1, luv);
  a = 1 - E**2;
  b = -2*D*E;
  c = -D**2
  d = b**2 - 4*a*c
  if (abs(d*a**2) < 1e-4)
    d = 0.0;
  endif
  d = sqrt(d);
  r = (-b + d)/(2*a)
  if (r < 0)
    r = (-b - d)/(2*a)
  endif
endfunction
