# This should be equivalent to Octave's projPointOnLine.
# The code is included for reference.

function rp = ProjectPointOnLine(l1, l2, p)
  if (abs(l2(1)-l1(1)) < 1e-8)
    rp(1) = l2(1);
    rp(2) = p(2);
  else
    m = (l2(2) - l1(2)) / (l2(1) - l1(1));
    b = l1(2) - m * l1(1);
    rp(1) = (m * p(2) + p(1) - m * b) / (m * m + 1);
    rp(2) = (m * m * p(2) + m * p(1) + b) / (m * m + 1);
  endif
endfunction
