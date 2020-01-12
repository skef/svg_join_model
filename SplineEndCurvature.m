# When at_end is false, returns the curvature at the start of spline s
# When at_end is true, returns the curvature at the end of spline s
# Calculations are taken from SVG 2 specification. 
#
# This implementation may not be appropriate for a spline end with a colocated 
# control point when the other control point is not co-located. Such splines
# have an undefined slope at that end. 
function cu = SplineEndCurvature(s, at_end)
  if (at_end==1)
    v1 = s(4, :) - s(3, :);
    v2 = s(2, :) - s(3, :);
  else
    v1 = s(2, :) - s(1, :);
    v2 = s(3, :) - s(2, :);
  endif
  l1_3 = norm(v1)**3;
  crs = Cross2D(v1, v2);
  if ( abs(crs) < 1e-12 )
    cu = 0;
  elseif ( abs(l1_3) < 1e-12 )
    cu = Inf;
  else
    cu = (2.0/3.0) * crs / l1_3;
  endif
endfunction
