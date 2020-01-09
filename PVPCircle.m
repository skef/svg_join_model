function [c, r] = PVPCircle(p1, v1, p2)
  n1 = Rotate90CCW(v1);
  p3 = (p1+p2)/2;
  n3 = Rotate90CCW(p2-p1);
  c = IntersectLines(p1, n1, p3, n3);
  r = norm(p1-c);
endfunction
