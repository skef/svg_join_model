# Returns the point the line defined by point lp and unit tangent "slope" luv 
# that is closest to point p
function rp = ProjectPointOnLine(p, lp, luv)
  rp = lp + dot(p-lp, luv)*luv;
endfunction
