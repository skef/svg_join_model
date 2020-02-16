function jl = CalcJoinLength(jp)
  # Formula is fsw/sin(theta/2) but sin(theta/2) = sqrt((1-cos(theta))/2)
  costheta = dot(jp.tv1, -1*jp.tv2);
  if (abs(costheta-1)<1e-5)
    jl = Inf;
  else
    jl = jp.sw / sqrt((1 - costheta)/2);
  endif
endfunction
