#!/usr/bin/env -S octave -qf

pkg load geometry

# Common configuration inputs 
stroke_width = 10;
join = "butt";

# Offset spline geometry inputs (comment out to enable alternate inputs)
s0 = [365.73 402.6; 365.73 404.6; 366.5 404.9; 367 405];
s2 = [367.45 406.9; 366.97 407.14; 366.46 407.26; 365.95 407.26];

# Alternate "stipulated" geometry inputs
p0 = [ -4, 3 ];
h0 = normalizeVector([ .8, -.3 ]);
cu0 = 0.017;
p2 = [ 2, -1 ];
h2 = normalizeVector([ 2.2, -3 ]);
cu2 = -.07;

###

if (exist("s0") != 0)
  p0 = s0(4, :);
  h0 = normalizeVector(p0 - s0(3, :));
  cu0 = SplineEndCurvature(s0, 1);
endif

if (exist("s2") != 0)
  p2 = s2(1, :);
  h2 = normalizeVector(s2(2, :) - p2);
  cu2 = SplineEndCurvature(s2, 0);
endif

if (cu0!=0)
  r0 = abs(1/cu0);
  sg0 = sign(1/cu0);
  cuv0 = rotateVector(h0, sg0*pi/2);
  c0 = p0 + cuv0 * r0;
else
  sg0 = 0;
endif
if (cu2!=0)
  r2 = abs(1/cu2);
  sg2 = sign(1/cu2);
  cuv2 = rotateVector(h2, sg2*pi/2);
  c2 = p2 + cuv2 * r2;
else
  sg2 = 0;
endif


if (cu0==0)
  if (cu2==0)
    "miterclip"
  else
    [cnt] = LineCircleTest(p0, p0+h0, c2, r2)
    if (cnt>0)
      [i1, i2] = IntersectLineCircle(p0, p0+h0, c2, r2);
    endif
  endif
elseif (cu2==0)
  [cnt] = CircleLineTest(p2, p2-h2, c0, r0)
  if (cnt>0)
    [i1, i2] = IntersectLineCircle(p2, p2-h2, c0, r0);
  endif
else
  [cnt] = CirclesTest(c0, r0, c2, r2)
  if (cnt>0)
    [i1, i2] = IntersectCircles(c0, r0, c2, r2);
  endif
endif

if (cnt > 1)
  refp = p0+h0;
  if (LineSameSide(p0, p2, i1, refp))
    if (LineSameSide(p0, p2, i2, refp))
      if (distancePoints(p0, i1) > distancePoints(p0, i2))
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
else
  i = i1
endif

figure;
hold on;
axis equal;
if (exist("s0") != 0)
  drawBezierCurve(s0);
endif
if (exist("s2") != 0)
  drawBezierCurve(s2);
endif
drawPoint(p0, 'color', 'blue');
drawPoint(p2, 'color', 'green');
#drawPoint(p0+h0)
if (cnt>0)
  drawPoint(i, 'color', 'black');
#  if (cnt>1)
#    drawPoint(i2, 'color', 'black');
#  endif
  if (cu0!=0)
    if (sg0>0)
      p0
      i
      c0
      vectorAngle(p0-c0)
      vectorAngle(i-c0)
      ext0 = rad2deg(vectorAngle(p0-c0, i-c0))
    else
      ext0 = -rad2deg(vectorAngle(i-c0, p0-c0))
    endif
    drawCircleArc(c0(1), c0(2), r0, rad2deg(vectorAngle(p0-c0)), ext0, 'color', 'red');
  else
    plot([p0(1) i(1)], [p0(2) i(2)]);
  endif
  if (cu2!=0)
    if (sg2>0)
      ext2 = -rad2deg(vectorAngle(i-c2, p2-c2));
    else
      ext2 = rad2deg(vectorAngle(p2-c2, i-c2));
    endif
    drawCircleArc(c2(1), c2(2), r2, rad2deg(vectorAngle(p2-c2)), ext2, 'color', 'magenta');
  else
    plot([p2(1) i(1)], [p2(2) i(2)]);
  endif
endif
#drawCircle(c0, r0);
#drawCircle(c2, r2);
waitforbuttonpress();
