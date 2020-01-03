function r = AdjustLineCircle(l1, l2, p1, v1)
  A = l2(2)-l1(2);
  B = l2(1)-l1(1);
  D = A*p1(1) - B*p1(2) + l2(1)*l1(2) - l2(2)*l1(1);
  E = A*v1(1) - B*v1(2);
  a = A**2 + B**2 - E**2;
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
