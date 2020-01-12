# cnt is the number of intersections between the two circles: 0, 1 or 2
# note is 
#   -1 if circle 2 is strictly inside 1,
#   -2 if circle 1 is inside circle 2, 
#   0 if the circles intersect, or
#   1 if the circles don't intersect and neither is inside the other
function [cnt, note] = CirclesTest(c1, r1, c2, r2)
  c_dist = norm(c1-c2);
  note = 0;
  cnt = 2;
  if (abs(c_dist - r1 - r2) < 1e-2)
    cnt = 1;
  elseif (c_dist > r1 + r2)
    cnt = 0;
    note = 1;
  elseif (c_dist < abs(r1 - r2))
    cnt = 0;
    if (r1 > r2)
      note = -1;
    else
      note = -2;
    endif
  endif
endfunction
