# Returns the center c and radius r of the circle containing points p1 and p2
# with tangent angle v1 at point p1.
# s is 1 if c is to the left of (90 degs CCW from) p1 relative to direction v1 
# and -1 if c is to the right of (90 degs CW from) p1 relative to direction v1
function [c, r, s] = PVPCircle(p1, v1, p2)
  n1 = Rotate90CCW(v1);
  p3 = (p1+p2)/2;
  n3 = Rotate90CCW(p2-p1);
  c = IntersectLines(p1, n1, p3, n3);
  cv = p1-c;
  r = norm(cv);
  s = sign(dot(n1, cv));
endfunction
