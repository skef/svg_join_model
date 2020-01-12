# Returns whichever of i1 or i2 is closer to refp, except that points on the
# same side of the line containing p1 and p2 as refp are "preferred".
#
# A warning is printed if both points are on the opposite side of that line
# from refp
function i = CloserIntersection(p1, p2, i1, i2, refp)
  if (LineSameSide(p1, p2, i1, refp))
    if (LineSameSide(p1, p2, i2, refp))
      i = CloserPoint(p1, i1, i2);
    else
      i = i1;
    endif
  else
    # The following could be replaced with just i = i2;
    if (!LineSameSide(p1, p2, i2, refp))
      warning("Both intersection points are behind bevel line -- probable incorrect calculation.");
      i = CloserPoint(p1, i1, i2);
    else
      i = i2;
    endif
  endif
endfunction
