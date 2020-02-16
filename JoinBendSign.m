# Returns            0 if the join angle doesn't change (or doubles back)
# Otherwise returns  1 if the join bends counterclockwise and
#                   -1 if it bends clockwise
function s = JoinBendSign(tv1, tv2)
  cp = Cross2D(tv1, tv2);
  if (abs(cp)<1e-8)
    cp = 0;
  endif
  s = sign(cp);
endfunction
