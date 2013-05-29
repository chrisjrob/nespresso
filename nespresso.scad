// nespresso.scad
// Nespresso Coffee Pod Dispenser
// 
// Copyright 2013 Christopher Roberts

// General parameters
thickness              =  2.0 ; // thickness of plastic
roundedness            =  0.7 ; // roundedness of boxes between 0 and 1
units                  =  4   ; // number of dispensers wide

// Box parameters
box_width              = 37.75; // width of box (37.5mm)
box_depth              = 38.25; // depth of box (38.0mm)
box_overhang           = 22.00; // overhang on opening

// Base parameters
base_width             = box_width * 1.25;
base_depth             = box_depth * 2;
base_thickness         = thickness * 3;
base_separation        = base_width - (base_width - box_width)/1.4;

use </usr/share/openscad/libraries/MCAD/boxes.scad>;

module nespresso_base() {

    difference() {

        // Things that exist
        union() {

            // flat base
            translate( v = [0, 0, base_thickness/2] ) {
                roundedBox( [base_width, base_depth, base_thickness], base_width * roundedness /10, true );
            }

        }

        // Things to be cut out
        union() {

            // tray cut-out from flat base
            translate( v = [0, -thickness/3, base_thickness] ) {
                # roundedBox( [box_width, base_depth - thickness * 2, base_thickness], box_width * roundedness/10, true );
            }

            // make back of cut-out square
            translate( v = [0, (base_depth - box_depth - thickness)/-2, base_thickness] ) {
                cube( size = [box_width, box_depth, base_thickness], center = true );
            }


        }
    }

}

module nespresso_base_tube() {

    difference() {

        // Things that exist
        union() {

            // outside of vertical tube
            translate( v = [0, (base_depth - box_depth - thickness * 2)/-2, base_thickness + box_width] ) {
                roundedBox( [box_width + thickness * 2, box_depth + thickness * 2, box_width * 2], box_width * roundedness/10, true );
            }

        }
       
        // Things to be cut out
        union() {
            
            // inside of vertical tube
            difference() {

                // tube
                translate( v = [0, (base_depth - box_depth - thickness * 2)/-2, base_thickness + box_width] ) {
                    cube( size = [box_width, box_depth, box_width*2], center = true );
                }

                // to stop cardboard tube slipping to the bottom
                union() {

                    // front
                    translate( v = [box_width/2 +0.1, thickness/2, base_thickness + box_width -0.1] ) {
                        rotate( a = [0,90,90] ) {
                            linear_extrude(height = thickness/2) polygon( points = [ [0,0], [0,box_width], [box_width, box_width], [box_width,0] ]);
                        }
                    }

                    // back
                    translate( v = [-box_width/2, -box_width + thickness*2 -thickness/2 -0.1, base_thickness -0.1]) {
                        rotate( a = [90,0,0] ) {
                            linear_extrude(height = thickness/2) polygon( points = [ [0,0], [0,box_width - box_overhang], [box_width, box_width - box_overhang], [box_width,0] ]);
                        }
                    }

                }

            }

            // archway - arch
            translate( v = [0, thickness, base_thickness + box_width/2] ) {
                rotate( a = [90, 0, 0] ) {
                    # cylinder( h = thickness *2, r = box_width/2, center = true );
                }
            }

            // archway - square
            translate( v = [0, thickness, base_thickness + box_width/2/2] ) {
                # cube( size = [box_width, thickness * 2, box_width/2], center = true );
                
            }


        }

    }

}

union() {
    for (z = [ base_separation : base_separation : units * base_separation ] ) {
        translate( v = [z - (units/2 * base_separation) - base_separation/2, 0, 0]) {
            nespresso_base();
            translate( v = [0,0,-base_thickness/2]) {
                nespresso_base_tube();
            }
        }
    }
}


