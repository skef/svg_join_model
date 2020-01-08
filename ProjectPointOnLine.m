function rp = ProjectPointOnLine(p, lp, luv)
  rp = lp + dot(p-lp, luv)*luv;
endfunction
