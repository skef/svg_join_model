function [i1] = IntersectLines(lp1, luv1, lp2, luv2)
  cl1 = Cross2D(luv1, lp1);
  cl2 = Cross2D(luv2, lp2);
  cd = Cross2D(luv1, luv2);
  if (abs(cd) < 1e-12)
    i1 = [Inf, Inf];
  else
    i1 = [(cl1*luv2(1) - cl2*luv1(1))/cd, (cl1*luv2(2) - cl2*luv1(2))/cd ];
  endif
endfunction
