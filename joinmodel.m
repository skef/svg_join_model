#!/usr/bin/env -S octave -qf

pkg load geometry

# Common parameters
join = "round";
miterlimit = 4;
strokewidth = 8;

# "Source" spline geometry inputs
#s1 = [355 396; 355 411; 365 421; 375 416];
#s2 = [375 416; 370 416; 360 406; 365 391];
#s1 = [375 396; 375 411; 365 421; 355 416];
#s2 = [355 416; 360 416; 370 406; 365 391];
#s1 = [355 396; 355 411; 365 421; 375 416];
#s2 = [375 416; 375 406; 372 405; 364 395];
#s1 = [346 425; 355 416; 364 414; 375 416];
#s2 = [375 416; 367 412; 360 406; 365 391];
#s1 = [375 425; 366 416; 357 414; 346 416];
#s1 = [354 398; 360 400; 372 412; 374 420];
#s2 = [374 420; 377 415; 373 396; 365 391];
s1 = [374 398; 368 400; 356 412; 354 420];
s2 = [354 420; 351 415; 355 396; 363 391];

#s1 = [363 402; 363 405; 365 407; 367 406];
#s2 = [367 406; 366 406; 364 404; 365 401];

# Compute derived parameters

jp.join = join;
jp.ojp = s1(4, :);       # The origin point of the join
jp.sw = strokewidth;     # The stroke width
if (exist("miterlimit") == 0)
  jp.ml = 4;             # SVG2 spec default
else
  jp.ml = miterlimit;
endif

jp.tv1 = normalizeVector(jp.ojp - s1(3, :));
jp.tv2 = normalizeVector(s2(2, :) - jp.ojp);

jp.jbs = JoinBendSign(jp.tv1, jp.tv2);
if (jp.jbs==-1)
  "Join bends clockwise, calculating for left side offset"
elseif (jp.jbs==1)
  "Join bends counter-clockwise, calculating for right side offset"
else
  "Join doesn't bend (sufficiently), nothing to calculate"
  quit;
endif

jp.p1 = jp.ojp - Rotate90CCW(jp.tv1) * jp.jbs * jp.sw/2;
jp.cu1 = SplineEndCurvature(s1, 1) / (1 + 2/jp.sw);

jp.p2 = jp.ojp - Rotate90CCW(jp.tv2) * jp.jbs * jp.sw/2;
jp.cu2 = SplineEndCurvature(s2, 0) / (1 + 2/jp.sw);

if (strcmp(join, "arcs"))
  jsa = ArcsJoin(jp);
elseif (strcmp(join, "miterclip") || strcmp(join,"miter"))
  jsa = MiterJoin(jp);
elseif (strcmp(join, "round"))
  jsa = RoundJoin(jp);
elseif (strcmp(join, "bevel"))
  jsa = {[jp.p1 jp.p2]};
else
  error("Join Type Unrecognized");
endif

figure;
hold on;
axis equal;
if (exist("s1") != 0)
  drawBezierCurve(s1);
endif
if (exist("s2") != 0)
  drawBezierCurve(s2);
endif
drawPoint(jp.p1, 'color', 'blue');
drawPoint(jp.p2, 'color', 'green');
for jsi = 1:length(jsa)
  if (numel(jsa{jsi})==5)
    drawCircleArc(jsa{jsi});
  elseif (numel(jsa{jsi})==4);
    plot([jsa{jsi}(1) jsa{jsi}(3)], [jsa{jsi}(2) jsa{jsi}(4)]);
  else
    warning("Unrecognized join segment");
    jsa{jsi}
  endif
endfor
waitforbuttonpress();
