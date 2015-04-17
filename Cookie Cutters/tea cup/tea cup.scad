// Cookie cutter using Minkowski sum
// Ed Nisley KE4ZNU - Sept 2011

[ -24.48, 16.08, 22.87 ]
module Original_SVG() {
    translate([-50,-150,0])
  linear_extrude(height = 10, center = false) {

polygon(points=[[430.23,301.69],[430.22,306.91],[430.05,308.15],[425.85,315.63],[418.28,323.05],[412.44,325.81],[406.76,326.67],[397.43,325.31],[391.98,323.49],[381.93,317.54],[379.95,315.96],[372.06,308.29],[363.59,299.42],[354.22,287.59],[347.75,271.14],[346.44,260.08],[345.61,252.24],[344.47,243.9],[343.61,238.66],[345.08,236.58],[353.49,236.3],[362.61,239.63],[386.95,251.76],[398.78,258.61],[412.64,268.56],[422.92,278.88],[427.52,287.1],[358.88,324.91],[359.85,324.57],[364.95,325.23],[382.89,333.75],[392.93,338.18],[402.68,339.8],[406.21,339.8],[419.16,338.14],[420.07,337.77],[421.42,337],[432.95,328.53],[434.2,327.03],[437.38,322.2],[441.9,312.56],[443.2,304.65],[443.22,302.53],[441.41,290.09],[435.57,277.2],[429.93,269.85],[412.75,254.44],[397.67,244.58],[357.14,222.93],[347.26,218.83],[337.3,214.9],[337.17,214.86],[331.59,212.62],[326.03,209.15],[325.45,208.75],[309.54,197.32],[306.11,194.61],[293.01,185.88],[287.73,180.56],[283.61,173.34],[282.09,171.53],[270.77,164.28],[260.96,160.84],[247.71,157.52],[237.43,155.88],[221.85,154.39],[214.38,154.54],[199.45,155.27],[186.23,156.25],[178.5,156.97],[175.18,157.54],[157.82,161.87],[155.59,162.71],[141.84,169.57],[138.75,172.32],[136.34,176.72],[136.12,177.23],[133.66,182.85],[129.24,187.83],[110.07,200.77],[107.61,202.64],[104.21,205.61],[92.03,218.87],[91.33,219.93],[88.85,224.03],[83.18,237.41],[76.89,263.57],[76.32,268.04],[74.26,292.92],[72.51,307.77],[71.86,316.62],[69.65,333.35],[66.38,342.77],[61.35,353.57],[63.85,356.27],[73.04,359.15],[85.86,361.09],[91.63,361.54],[122.88,363.47],[137.82,364.13],[160.24,365.1],[162.21,365.15],[246.31,365.13],[259.28,364.6],[274.63,363.84],[293.77,362.54],[309.1,361.31],[325.55,360.02],[337.93,359.08],[346.14,357.86],[354.16,356.27],[361.02,354.18],[361.72,353.73],[363.36,349.63],[361.49,338.81]], paths=[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26],[27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114]]);

}
}

//- Extrusion parameters - must match reality!

ThreadThick = 0.33;
ThreadWidth = 2.0 * ThreadThick;

function IntegerMultiple(Size,Unit) = Unit * ceil(Size / Unit);

MaxSize = 11000;              // larger than any possible dimension ...

//- Cookie cutter parameters

Size = 50;

TipHeight = IntegerMultiple(15,ThreadThick);
TipThick = 1*ThreadWidth;

WallHeight = IntegerMultiple(2,ThreadThick);
WallThick = 4*ThreadWidth;

LipHeight = IntegerMultiple(1.5,ThreadWidth);
LipThick = IntegerMultiple(5,ThreadWidth);

//- Wrapper for the shape of your choice

module Shape(Size) {
  Cutter(Size);
}

//- A solid slab of cookie cutter shape goodness in simple STL format
// Choose magic values to:
//      center it in XY
//      reversed across Y axis (prints with handle on bottom)
//      bottom on Z=0
//      make it MaxSize from head to feet

module Cutter(Scale) {
  STLscale = 250;
  scale(Scale/STLscale)
    //translate([105,-145,0])
      scale([-1,1,24])
        Original_SVG();
}

//- Given a Shape(), return enlarged slab of given thickness

module EnlargeSlab(Scale, WallThick, SlabThick) {

    intersection() {
      translate([0,0,SlabThick/2])
        cube([MaxSize,MaxSize,SlabThick],center=true);
      minkowski() {
        Shape(Scale);
        cylinder(r=WallThick,h=MaxSize);
      }
    }

}

//- Put peg grid on build surface

module ShowPegGrid(Space = 10.0,Size = 1.0) {

  Range = floor(50 / Space);

    for (x=[-Range:Range])
      for (y=[-Range:Range])
        translate([x*Space,y*Space,Size/2])
          %cube(Size,center=true);

}

//- Build it

//ShowPegGrid();

//cube(5);

difference() {
  union() {
    translate([0,0,(WallHeight + LipHeight)])
      EnlargeSlab(Size,TipThick,TipHeight);
    translate([0,0,LipHeight])
      EnlargeSlab(Size,WallThick,WallHeight);
    EnlargeSlab(Size,LipThick,LipHeight);
  }
  Shape(Size);                  // punch out cookie hole
};