function d = PointLineDistance(p, lp, luv)
  d = norm(p-ProjectPointOnLine(p, lp, luv));
endfunction
