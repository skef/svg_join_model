function i = CloserIntersection(p1, p2, i1, i2, refp)
  if (LineSameSide(p1, p2, i1, refp))
    if (LineSameSide(p1, p2, i2, refp))
      if (norm(p1-i1) > norm(p1-i2))
        i = i2;
      else
        i = i1;
      endif
    else
      i = i1;
    endif
  else
    i = i2;
  endif
endfunction
