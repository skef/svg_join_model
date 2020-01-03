function e = AdjustCircles(p1, v1, r1, p2, v2, r2, inside)
  if (inside)
    fac = -1;
  else
    fac = 1;
  endif
  Ax = p1(1) - p2(1) + r1*v1(1) - r2*v2(1);
  Ay = p1(2) - p2(2) + r1*v1(2) - r2*v2(2);
  Bx = fac*v1(1) - v2(1);
  By = fac*v1(2) - v2(2);
  C = r1 + fac*r2;
  D = fac*2;
  c = Ax**2 + Ay**2 - C**2;
  b = 2*(Ax*Bx + Ay*By - C*D);
  a = Bx**2 + By**2 - D**2;
  d = b**2 - 4*a*c
  if (abs(d*a**2) < 1e-4)
    d = 0.0;
  endif
  d = sqrt(d);
  e = (-b + d)/(2*a)
  if (e < 0)
    e = (-b - d)/(2*a)
  endif
endfunction
