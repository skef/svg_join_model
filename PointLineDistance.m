# Returns the distance between point p and the line defined by point lp and
# unit tangent "slope" luv. 
function d = PointLineDistance(p, lp, luv)
  d = norm(p-ProjectPointOnLine(p, lp, luv));
endfunction
