plateThickness = 3;
plateScrewSpacing = 30;
plateScrewDiameter = 3;
shaftThickness = 3;
shaftHeight = 40;
bearingOuterDiameter = 28;
bearingInnerDiameter = 12;
bearingHeight = 8;

plateScrewRadius = plateScrewDiameter / 2;
bearingOuterRadius = bearingOuterDiameter / 2;
bearingInnerRadius = bearingInnerDiameter / 2;

$fn = 50;

module screw_outer()
{
    translate([0, plateScrewSpacing, 0])
        circle(plateScrewRadius + plateThickness);
}

module screw_inner()
{
    translate([0, plateScrewSpacing, 0])
        circle(plateScrewRadius);
}

module plate()
{
    difference()
    {
        hull()
        {
            screw_outer();
            rotate([0, 0, 360 / 3])
                screw_outer();
            rotate([0, 0, -360 / 3])
                screw_outer();
        }

        screw_inner();
        rotate([0, 0, 360 / 3])
            screw_inner();
        rotate([0, 0, -360 / 3])
            screw_inner();
    }
}

module mount()
{
    baseRadius = (bearingOuterRadius + plateScrewSpacing) / 4;

    translate([bearingOuterRadius, 0, 0])
        square([shaftThickness, shaftHeight]);

    difference()
    {
        translate([bearingOuterRadius + shaftThickness, 0, 0])
            square(baseRadius);

        translate([baseRadius + bearingOuterRadius + shaftThickness, baseRadius, 0])
            circle(baseRadius);
    }
}

module bracket()
{
    linear_extrude(plateThickness)
        plate();

    intersection()
    {
        linear_extrude(plateThickness + shaftHeight)
            plate();

        translate([0, 0, plateThickness])
            rotate_extrude(angle = 360, convexity = 3)
            mount();
    }
}

module spacer()
{
    translate([0, 0, plateThickness + bearingHeight])
        linear_extrude(shaftHeight - (bearingHeight * 2))
        difference()
    {
        circle(bearingInnerRadius + 2);
        circle(bearingInnerRadius);
    }
}

bracket();
spacer();