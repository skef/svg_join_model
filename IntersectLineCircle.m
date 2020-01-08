function [i1, i2] = IntersectLineCircle(lp, luv, c1, r1)
  pp = ProjectPointOnLine(c1, lp, luv);
  t = c1-pp;
  sqdiff = r1**2 - t(1)**2 - t(2)**2;
  if (abs(sqdiff)<1e-4)
    i1 = i2 = pp;
    return;
  endif
  perp = luv*sqrt(sqdiff);
  i1 = pp + perp;
  i2 = pp - perp;
endfunction
