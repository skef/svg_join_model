function jl = CalcJoinLength(jp, costheta)
  # Angle of interest is pi - theta, so formula is fsw/sin((pi - theta)/2)
  #   = sin(pi/2 - theta/2) 
  #   = sin(pi/2)cos(theta/2) - cos(pi/2)sin(theta/2)
  #   = 1 * cos(theta/2) - 0 * sin(theta/2) 
  #   = cos(theta/2)
  #   = sqrt((1 + cos(theta))/2)
  #   = sqrt((1 + dot(tv1, tv2))/2)
  costheta = dot(jp.tv1, jp.tv2);
  if (abs(costheta+1)<1e-5)
    jl = Inf;
  else
    jl = jp.sw / sqrt((1 + dot(jp.tv1, jp.tv2))/2);
  endif
endfunction
