# The magnitude of the 2d cross product of v1 and v2 is returned 
function r = Cross2D(v1, v2)
  r = v1(1) * v2(2) - v1(2) * v2(1);
endfunction
