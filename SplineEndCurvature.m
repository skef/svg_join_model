function cu = SplineEndCurvature(s, at_end)
  if (at_end==1)
    v1 = s(4, :) - s(3, :);
    v2 = s(2, :) - s(3, :);
  else
    v1 = s(2, :) - s(1, :);
    v2 = s(3, :) - s(2, :);
  endif
  l1_3 = norm(v1)**3;
  if ( abs(l1_3) < 1e-15 )
    cu = Inf;
  else
    cu = (2.0/3.0) * Cross2D(v1, v2) / l1_3;
  endif
  if (abs(cu) < 1e-4)
    cu = 0;
  endif
endfunction
