// nespresso coffee pod dispenser

// Global Parameters
pod_rim_diameter       = 37.10; // widest part of the pod
pod_rim_thickness      =  1.40; // thickness of rim
pod_barrel_diameter    = 29.75; // widest part of the pod barrel
pod_depth              = 29.30; // height of pod when sitting on cap
thickness              =  2   ; // thickness of plastic
spacing                =  1   ; // spacing around pods
height_in_pods         =  3   ; // height in number of pods - ensure you have sufficient print height

// Calculated parameters - you should avoid changing
rim_overlap            = pod_rim_diameter - pod_barrel_diameter;
height                 = height_in_pods * pod_rim_diameter;
width                  = pod_rim_diameter + 2 * thickness + 2 * spacing; 
depth                  = pod_rim_thickness + 2 * thickness + 2 * spacing;
overlap                = pod_rim_diameter -pod_barrel_diameter +thickness -spacing;
base_height            = 0.9 * pod_rim_diameter; // increase factor if pod does not drop out easily and vice versa

module nespresso_base() {

    difference() {

        // Things that exist
        union() {

            // alternative base
            translate( v = [100, 0, 0] ) {
                rotate( a = [0, 0, 180] ) {
                    import_stl("Nesspresso_dispenser.stl");
                }
            }

            // base
            translate( v = [-width/2, 0, 0] ) {
                cube(size = [width,pod_depth+thickness,thickness]);
            }
            // back of base
            translate( v = [-width/2, 0, thickness] ) {
                cube(size = [width,thickness,base_height]);
            }
            // front of base
            translate( v = [-width/2, pod_depth, thickness] ) {
                cube(size = [width,thickness,pod_rim_diameter/4]);
            }
            // left of base
            for (x = [-width/2, width/2 - thickness] ) {
                translate( v = [x, 0, thickness] ) {
                    cube(size = [thickness,pod_depth,pod_rim_diameter/4]);
                }
            }

        }

        // Things to be cut out
        union() {

        }
    }

}

module nespresso_shaft() {

    difference() {

        // Things that exist
        union() {
            translate(v = [0,0,0]) {
                linear_extrude(height = height, center = false) {
                polygon(points = [  [-width/2, 0],
                                    [ width/2, 0],
                                    [ width/2, depth],
                                    [ width/2 -overlap, depth],
                                    [ width/2 -overlap, depth -thickness],
                                    [ width/2 -thickness, depth -thickness],
                                    [ width/2 -thickness, thickness],
                                    [-width/2 +thickness, thickness],
                                    [-width/2 +thickness, depth -thickness],
                                    [-width/2 +overlap, depth -thickness],
                                    [-width/2 +overlap, depth],
                                    [-width/2, depth] ],
                        paths =   [ [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ] ] );
                }
            }
        }

        // Things to be cut out
        union() {

        }
    }

}

translate( v = [0, 0, base_height + thickness ]) {
    nespresso_shaft();
}
nespresso_base();

// http://en.wikibooks.org/wiki/OpenSCAD_User_Manual

// primitives
// cube(size = [1,2,3], center = true);
// sphere( r = 10, $fn=100 );
// circle( r = 10 );
// cylinder( h = 10, r = 20, $fs = 6, center = true );
// cylinder( h = 10, r1 = 10, r2 = 20, $fs = 6, center = false );
// polyhedron(points = [ [x, y, z], ... ], triangles = [ [p1, p2, p3..], ... ], convexity = N);
// polygon(points = [ [x, y], ... ], paths = [ [p1, p2, p3..], ... ], convexity = N);

// transormations
// scale(v = [x, y, z]) { ... }
// rotate(a=[0,180,0]) { ... }
// translate(v = [x, y, z]) { ... }
// mirror([ 0, 1, 0 ]) { ... }

// rounded box by combining a cube and single cylinder
// $fn=50;
// minkowski() {
//   cube([10,10,1]);
//   cylinder(r=2,h=1);
// }

// hull() {
//   translate([15,10,0]) circle(10);
//   circle(10);
// }

// import_dxf(file="design.dxf", layer="layername", origin = [100,100], scale = 0.5);
// linear_extrude(height = 10, center = true, convexity = 10, twist = 0, $fn = 100)
// rotate_extrude(convexity = 10, $fn = 100)
// import_stl("example012.stl", convexity = 5);

// for (z = [-1, 1] ) { ... } // two iterations, z = -1, z = 1
// for (z = [ 0 : 5 ] ) { ... } // range of interations step 1
// for (z = [ 0 : 2 : 5 ] ) { ... } // range of interations step 2

// for (i = [ [ 0, 0, 0 ], [...] ] ) { ... } // range of rotations or vectors
// usage say rotate($i) or translate($i)
// if ( x > y ) { ... } else { ... }
// assign (angle = i*360/20, distance = i*10, r = i*2)
