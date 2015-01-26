//VARIABLES
2D_resolution = 25; //the $fn value on all 2D objects. I find 50 good to edit with, and 250 produces smooth prints. 
3D_resolution = 25; //the $fn value on all 3D objects. I find 50 good to edit with, and 250 produces smooth prints.
height_multiplier = 10;
width_multiplier = 10;
ped_height = 20;
//ped_taper_angle
ped_base_radius = 20;
main_radius = 10;
main_radius_vertical_offset = -20;
top_radius = 27;
top_radius__vertical_offset = -15;
minkowski_sphere_radius = 3;



//COMPUTED VARIABLES
main_circle_y_translation = (ped_height + main_radius_vertical_offset + main_radius);
top_circle_y_translation = (main_circle_y_translation + main_radius + top_radius__vertical_offset + top_radius);

halfing_square_width = (main_radius >= top_radius) ? main_radius : top_radius;
halfing_square_height = (2*main_radius + top_radius + ped_height);




//MODULES
module body() {
    rotate_extrude($fn=3D_resolution){
        difference(){
            union(){
                translate([0,(main_circle_y_translation),0]) circle(main_radius, $fn=2D_resolution);
                translate([0,(top_circle_y_translation),0]) circle(top_radius, $fn=2D_resolution);
            }
            translate([(-1*halfing_square_width),0,0])square([halfing_square_width,halfing_square_height]);
            translate([(-1*top_radius),(top_circle_y_translation),0]) square((2*top_radius));
        }
    }
}

module pedestal() {
	rotate_extrude($fn=3D_resolution){
		polygon([[(-1*ped_base_radius),0],[ped_base_radius,0],[0,ped_height]]);
	}
}

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
	resize(newsize=[width_multiplier, width_multiplier, height_multiplier]) main();
}

make_cup();
