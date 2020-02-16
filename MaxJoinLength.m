# Returns the maximum join length given the supplied miterlimit and strokewidth.
function mjl = MaxJoinLength(jp)
  mjl = jp.ml * jp.sw;
endfunction
