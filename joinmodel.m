#!/usr/bin/env -S octave -qf

pkg load geometry

# Common parameters
# join = "arcs";
join = "miterclip";
miterlimit = 2;
# join = "round";

# Offset spline geometry inputs (comment out to enable alternate inputs)
s1 = [365.73 402.6; 365.73 404.6; 366.5 404.9; 367 405];
s2 = [367.45 406.9; 366.97 407.14; 366.46 407.26; 365.95 407.26];

# Alternate "stipulated" geometry inputs
p1 = [ 1, 0 ];
tv1 = normalizeVector([ 0, 1 ]);
cu1 = -0.3;
p2 = [ 0, 1 ];
tv2 = normalizeVector([ 1, 0 ]);
cu2 = -.05;

# Compute derived parameters

if (exist("s1") != 0)
  p1 = s1(4, :);
  tv1 = normalizeVector(p1 - s1(3, :));
  cu1 = SplineEndCurvature(s1, 1);
endif

if (exist("s2") != 0)
  p2 = s2(1, :);
  tv2 = normalizeVector(s2(2, :) - p2);
  cu2 = SplineEndCurvature(s2, 0);
endif

if (exist("miterlimit") == 0)
  miterlimit = 4; # SVG2 spec default
endif

ojp = IntersectLines(p1, rotateVector(tv1, pi/2), p2, rotateVector(tv2, pi/2));

d1 = norm(ojp-p1);
d2 = norm(ojp-p2);
if (abs(d1-d2) >= .5)
  warning("Offsets (based on normal vector intersection) differ by more than .5 -- clipping geometry and round join will be invalid");
endif
sw = d1+d2;

jp.join = join;     # The join type
jp.ojp = ojp;       # The origin point of the join
jp.sw = sw;         # The stroke width
jp.jbs = JoinBendSign(tv1, tv2)
jp.ml = miterlimit; # stroke-miterlimit
jp.p1 = p1;         # The end of the offset curve 1
jp.tv1 = tv1;       # Its unit tangent vector
jp.cu1 = cu1;       # Its curvature
jp.p2 = p2;         # The start of offset curve 2
jp.tv2 = tv2;       # Its unit tangent vector
jp.cu2 = cu2;       # Its curvature

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
drawPoint(jp.ojp, 'color', 'red', 'marker', '+');
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
