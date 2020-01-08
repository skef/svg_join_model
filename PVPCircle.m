function [c, r] = PVPCircle(p1, v1, p2)
  n1 = rotateVector(v1, pi/2);
  p3 = (p1+p2)/2;
  n3 = rotateVector(p2-p1, pi/2);
  c = IntersectLines(p1, n1, p3, n3);
  r = norm(p1-c);
endfunction
