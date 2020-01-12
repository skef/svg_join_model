# Returns whichever of points p1 or p2 is closer to point r
function p = CloserPoint(r, p1, p2)
  d1 = p1-r;
  d2 = p2-r;
  if (dot(d1,d1) > dot(d2,d2))
     p = p2;
  else
     p = p1;
  endif
endfunction
