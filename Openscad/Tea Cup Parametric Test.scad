//VARIABLES
2D_resolution = 25; //the $fn value on all 2D objects. I find 50 good to edit with, and 250 produces smooth prints. 
3D_resolution = 25; //the $fn value on all 3D objects. I find 50 good to edit with, and 250 produces smooth prints.
height_multiplier = 1;
width_multiplier = 1;
ped_height = 20;
//ped_taper_angle
ped_base_radius = 15;
bottom_radius = 40;
bottom_radius_vertical_offset = 0;
top_radius = 45;
top_radius__vertical_offset = 0;
waist_radius = 65;
waist_height = 25;
waist_vertical_offset = 0;
minkowski_sphere_radius = 3;



//COMPUTED VARIABLES
bottom_circle_y_translation = (ped_height + bottom_radius_vertical_offset + bottom_radius);
top_circle_y_translation = (bottom_circle_y_translation + bottom_radius + top_radius__vertical_offset + top_radius);
waist_y_translation = ((0.5*(top_circle_y_translation - bottom_circle_y_translation)) + bottom_circle_y_translation);
halfing_square_width = bottom_radius > top_radius ? bottom_radius : top_radius;
halfing_square_height = (2*bottom_radius + top_radius + ped_height);




//MODULES
module body() {
//  rotate_extrude($fn=3D_resolution){
        difference(){
            hull(){
                translate([0,(bottom_circle_y_translation),0]) circle(bottom_radius, $fn=2D_resolution); //bottom circle
                translate([0,(top_circle_y_translation),0]) circle(top_radius, $fn=2D_resolution); // top circle
            }
            translate([waist_radius,waist_y_translation,0]) circle(waist_height, $fn=2D_resolution)
            translate([(-1*halfing_square_width),0,0]) square([halfing_square_width,halfing_square_height]); // halfing square
            translate([(-1*top_radius),(top_circle_y_translation),0]) square((2*top_radius)); //cut off the top after half of the top circle
    	}    	
//	}
}

module pedestal() {
//	rotate_extrude($fn=3D_resolution){
		polygon([[0,0],[ped_base_radius,0],[0,ped_height]]);
	}
//}

module body_smoothed() {
	minkowski(){	
	    body();
	    sphere(minkowski_sphere_radius, center=true);
	}
}

module main() {
	union(){
		body();
		//body_smoothed();
		pedestal();
	}
}

module make_cup(){
	//resize(newsize=[width_multiplier, width_multiplier, height_multiplier]) main();
	main();
}

make_cup();
