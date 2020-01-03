function r = LineSameSide(l1, l2, p, r)
  tp = (l2(1)-l1(1))*(p(2)-l1(2)) - (p(1)-l1(1))*(l2(2)-l1(2));
  tr = (l2(1)-l1(1))*(r(2)-l1(2)) - (r(1)-l1(1))*(l2(2)-l1(2));
  if (abs(tp) < 1e-5)
    r = 0;
  else
    r = (sign(tr)==sign(tp));
  endif
endfunction
