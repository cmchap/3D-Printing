#target illustrator

var docRef = app.activeDocument;
var selRef = docRef.selection;

var strPolygons = "";

if (selRef.length == 0) {
	alert("Please select an object.");
} else {
	for (i=0; i<selRef.length; i++) {
		var strPoints = "";
		var strPaths = "";
		var pos_x = selRef[i].position[0]*0.352777778;
		var pos_y = selRef[i].position[1]*0.352777778;

		var pathsCounter = 0;

		var pathRef = selRef[i];

		if (pathRef.typename == "GroupItem") {
			alert("Grouped items don't work just yet.");

		} else if (pathRef.typename == "CompoundPathItem") {
			for (j=0; j<pathRef.pathItems.length; j++) {
				if (j != 0) {
					strPoints += ",";
					strPaths += "],[";
				}
				for (k=0; k<pathRef.pathItems[j].pathPoints.length; k++) {
					var tempX = pathRef.pathItems[j].pathPoints[k].anchor[0]*0.352777778;
					tempX = tempX-pos_x;
					tempX = tempX.toFixed(2);
					var tempY = pathRef.pathItems[j].pathPoints[k].anchor[1]*0.352777778;
					tempY = tempY-pos_y;
					tempY = tempY.toFixed(2);
					if (k != 0) {
						strPoints += ",";
						strPaths += ",";
					}
					strPoints += "["+tempX+","+tempY+"]";
					strPaths += pathsCounter;
					pathsCounter++;
				}
			}
			strPolygons += "[["+strPoints+"],[["+strPaths+"]]]";

		} else {
			for (j=0; j<pathRef.pathPoints.length; j++) {
				if (j != 0) {
					strPoints += ",";
				}
				var tempX = pathRef.pathPoints[j].anchor[0]*0.352777778;
				tempX = tempX-pos_x;
				tempX = tempX.toFixed(2);
				var tempY = pathRef.pathPoints[j].anchor[1]*0.352777778;
				tempY = tempY-pos_y;
				tempY = tempY.toFixed(2);
                if (j != 0) {
                        strPoints += ",";
                        strPaths += ",";
                    }
				strPoints += "["+tempX+","+tempY+"]";
                strPaths += pathsCounter;
                pathsCounter++;
			}
			strPolygons += "[["+strPoints+"],[["+strPaths+"]]]";
		}
	}

	var tName = prompt("Document Name \r .scad extension added automatically. Will overwrite files without warning!", "paths_to_cookie_cutter_output");
	if (tName != null) {
		var textFile = File('~/Downloads/'+tName+'.scad');
		textFile.lineFeed = "Unix";
		textFile.open('w');
		textFile.writeln("//Cookie Cutter\n// Cory Chapman - April 2015, forked from http://www.thingiverse.com/thing:116042\n\nscale = 100; //total size of the cookie cutter as a percentage of the original image. This will be overridden by the x_size and y_size parameters below\nwall_thickness = 0.8; //[1.6:Thicker,.8:Thinner]\nheight = 30; //[15:Short,30:Tall]\nmiddle_outline_height = 5;\n\n//Note These size changes do not work for cookies with interior holes. \nx_size = 0; //desired X dimension in millimeters. Leave as 0 to scale proportional to Y. This will override the scale parameter above.\ny_size = 0; //desired Y dimension in millimeters. Leave as 0 to scale proportional to X. This will override the scale parameter above.\n\n//Set to Yes to make the cookies look like the drawing\nmirror = \"Yes\"; //[Yes,No]\n\n//Holds up interior holes\nsupport_grid = \"Yes\"; //[Yes,No]\n\nshape = "+strPolygons+";\n\nif(mirror == \"No\"){\n    cookie_cutter(shape);\n} else {\n    if(len(shape[0]) > 0) {\n        scale([-1,1,1])\n            cookie_cutter(shape);\n    } else {\n        cookie_cutter(shape);\n    }\n}\n\nmodule grid(){\ntranslate([-1000,-1000])\n    for(i = [0:100]){\n        translate([20*i,0])\n        square([5,10000], center = true);\n    }\nrotate([0,0,90])\n    translate([-1000,-1000])\n        for(i = [0:100]){\n            translate([20*i,0])\n            square([5,10000], center = true);\n        }\n\n}\n\nmodule outset(shape,path_index,dist){\n\n        minkowski(){\n            resize([x_size, y_size, 0], auto=[true,true,false]) polygon(points = shape[0], paths = [shape[1][path_index]], convexity = 10);\n            circle(r=dist);\n        }\n\n    \n}\n\nmodule cookie_cutter (shape){\n    if(len(shape[0])>3){\n        if(len(shape[1])>1){\n        //scale([1*scale,1*scale,1])\n        linear_extrude(height=wall_thickness)\n            if (support_grid == \"No\"){\n                for(i = [1:len(shape[1])-1]){   \n                    outset(shape,i,1);\n                }\n            } else {\n                intersection(){\n                    grid();\n                    for(i = [1:len(shape[1])-1]){   \n                        outset(shape,i,1);\n                    }\n                }\n            }\n        }\n        for(i = [0:len(shape[1])-1]){   \n        //Innermost outline\n        translate([0,0,wall_thickness/2]) \n            linear_extrude(height=height)\n                difference(){\n                    outset(shape,i,wall_thickness);\n                    resize([x_size, y_size, 0], auto=[true,true,false]) polygon(points=shape[0]*(scale/100), paths=[shape[1][i]]);\n                }\n        //Middle outline\n        translate([0,0,wall_thickness/2]) \n        linear_extrude(height=middle_outline_height) \n            difference(){\n                outset(shape,i,3);\n                resize([x_size, y_size, 0], auto=[true,true,false]) polygon(points=shape[0]*(scale/100), paths=[shape[1][i]]);\n            }    \n        //outermost outline\n        linear_extrude(height=wall_thickness*2) \n            difference(){\n                outset(shape,i,5);\n                resize([x_size, y_size, 0], auto=[true,true,false]) polygon(points=shape[0]*(scale/100), paths=[shape[1][i]]);\n            }\n        }\n    } else {\n        write(\"<-- Draw A Shape\");\n    }\n}\n\n");
		textFile.close();

		alert("Yay! Check your ~/Downloads folder.");
	}
}
