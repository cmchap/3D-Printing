fn = 100;
union(){
	difference(){
		translate ([0,0,2]) cylinder(r1=27, r2=37, h=95, $fn=fn); 
		translate ([0,0,2]) cylinder(r1=26, r2=36, h=95, $fn=fn);
	};
	cylinder(r=27, h=2, $fn=fn);
}