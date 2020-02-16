#!/usr/bin/env -S octave -qf

pkg load geometry

# Common parameters
join = "arcs";
miterlimit = 4;
strokewidth = 10;

# "Source" spline geometry inputs
s1 = [355 396; 355 411; 365 421; 375 416];
s2 = [375 416; 370 416; 360 406; 365 391];
#s1 = [375 396; 375 411; 365 421; 355 416];
#s2 = [355 416; 360 416; 370 406; 365 391];
#s1 = [355 396; 355 411; 365 421; 375 416];
#s2 = [375 416; 375 406; 372 405; 364 395];
#s1 = [346 425; 355 416; 364 414; 375 416];
#s2 = [375 416; 367 412; 360 406; 365 391];
#s1 = [375 425; 366 416; 357 414; 346 416];
#s1 = [354 398; 360 400; 372 412; 374 420];
#s2 = [374 420; 377 415; 373 396; 365 391];
#s1 = [374 398; 368 400; 356 412; 354 420];
#s2 = [354 420; 351 415; 355 396; 363 391];

#s1 = [0 0; 25 40; 50 85; 200 100];
#s2 = [200 100; 50 115; 25 160; 0 200];

#s1 = [0 0; 25 40; 50 85; 200 100];
#s1 = [0 0; 122 -11; 182 22; 200 100];
#s2 = [200 100; 200 100; 0 100; 0 100];

#s1 = [363 402; 363 405; 365 407; 367 406];
#s2 = [367 406; 366 406; 364 404; 365 401];

# cusp
#s1 = [234.76 -15; 234.76 -15; 236 -13; 236 -13];
#s2 = [236 -13; 235 -14; 233 -14; 231 -14];

# Compute derived parameters

jp.join = join;
jp.ojp = s1(4, :);       # The origin point of the join
jp.sw = strokewidth;     # The stroke width
if (exist("miterlimit") == 0)
  jp.ml = 4;             # SVG2 spec default
else
  jp.ml = miterlimit;
endif

if (jp.ojp == s1(3, :))
  jp.tv1 = normalizeVector(jp.ojp - s1(1, :));
else
  jp.tv1 = normalizeVector(jp.ojp - s1(3, :));
endif
if (jp.ojp == s2(2, :))
  jp.tv2 = normalizeVector(s2(4, :) - jp.ojp);
else
  jp.tv2 = normalizeVector(s2(2, :) - jp.ojp);
endif

jp.jbs = JoinBendSign(jp.tv1, jp.tv2);
if (jp.jbs==-1)
  "Join bends clockwise, calculating for left side offset"
  jp.dir = "left";
elseif (jp.jbs==1)
  "Join bends counter-clockwise, calculating for right side offset"
  jp.dir = "right";
else
  "Join doesn't bend (sufficiently), nothing to calculate"
  quit;
endif

jp.p1 = jp.ojp - Rotate90CCW(jp.tv1) * jp.jbs * jp.sw/2;
raw_cu1 = SplineEndCurvature(s1, 1);
cu1 = raw_cu1 / (1 + jp.jbs * raw_cu1 * jp.sw / 2);
if (sign(raw_cu1) == sign(cu1))
  jp.cu1 = cu1;
else
  warning("Incoming spline end on cusp -- using source spline curvature.");
  jp.cu1 = raw_cu1;
endif

jp.p2 = jp.ojp - Rotate90CCW(jp.tv2) * jp.jbs * jp.sw/2;
raw_cu2 = SplineEndCurvature(s2, 0);
cu2 = raw_cu2 / (1 + jp.jbs * raw_cu2 * jp.sw / 2);
if (sign(raw_cu2) == sign(cu2))
  jp.cu2 = cu2;
else
  warning("Outgoing spline end on cusp -- using source spline curvature.");
  jp.cu2 = raw_cu2;
endif

if (strcmp(join, "arcs"))
  jsa = ArcsJoin(jp);
elseif (strcmp(join, "miterclip") || strcmp(join,"miter"))
  jsa = MiterJoin(jp);
elseif (strcmp(join, "round"))
  jsa = RoundJoin(jp);
elseif (strcmp(join, "bevel"))
  jsa = {{jp.p1 jp.p2}};
else
  error("Join Type Unrecognized");
endif

# Display results 

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
    c = jsa{jsi}{1};
    r = jsa{jsi}{2};
    sgn = jsa{jsi}{5};
    v1 = jsa{jsi}{3};
    v2 = jsa{jsi}{4};
    if (sgn>0)
      ext = rad2deg(vectorAngle(v1, v2));
    else
      ext = -rad2deg(vectorAngle(v2, v1));
    endif
    drawCircleArc([c(1), c(2), r, rad2deg(vectorAngle(v1)), ext]);
  elseif (numel(jsa{jsi})==2);
    pp1 = jsa{jsi}{1};
    pp2 = jsa{jsi}{2};
    plot([pp1(1) pp2(1)], [pp1(2) pp2(2)]);
  else
    warning("Unrecognized join segment");
    jsa{jsi}
  endif
endfor
waitforbuttonpress();
