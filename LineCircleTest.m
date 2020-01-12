# Returns the number of intersections between the line and circle.
# The line is defined as a point and a unit tangent "slope".
function cnt = LineCircleTest(lp, luv, c1, r1)
  cl_dist = PointLineDistance(c1, lp, luv);
  cnt = 2;
  if (abs(cl_dist-r1) < 1e-2)
    cnt = 1;
  elseif (cl_dist > r1)
    cnt = 0;
  endif
endfunction
