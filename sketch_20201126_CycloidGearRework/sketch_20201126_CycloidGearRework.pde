/*
 Recommended to watch this video:
 https://www.youtube.com/watch?v=ygcGfnVM6Ho
 
 This project is based on that mechanism, except some physical
 constraints have been ignored.  
 */


Gear pivotGear;
Gear fulcrumGear;
Gear BASE;
Pin PIVOT, FULCRUM;
OSC PENDIST, PENOFF;

// scale factor
float SCL = 100;    

// teeth on BASE gear
// Used to properly scale gear size and angular velocity
int BASETEETH;   

// Angular velocity of BASE gear
// Scales angular velocity of other gears
float VEL = PI/2;

// current "angle time" and time increment
// time used in turning the gears but not changing any positions
float a_t = 0;
float da_t = 0.04;

// "position time" (increments with framecount)
// time used to calculate any oscillating values
float pos_t = 0;
// number of frames in a perfect loop
// Increase for slower animation
int FRAMES = 300;

// keeps track of pen point
PVector prev_point;

// switch from draw mode to "gear view" with SPACE
int mode = 0;

boolean pause = false;

void setup() {
  size(700, 700);

  // Some good gear values:
  // base teeth options; 120, 144, 150
  // gear teeth options: 30, 32, 34, 36, 40, 48, 50, 58, 60, 66, 72, 74, 80, 90, 94, 98, 100

  //

SCL = 220;
  BASETEETH = 150;
  BASE = new FreeGear()
    .setCenterX(0, 0, 0, 0)
    .setCenterY(0, 0, 0, 0)
    .setTeeth(BASETEETH)
    .setDir(-1)
    ;

  fulcrumGear = new FreeGear()
    .setCenterX(-1.2, 0, 0, 0)
    .setCenterY(-1.2, 0, 0, 0)
    .setTeeth(94)
    .setDir(1)
    ;

  pivotGear = new FreeGear()
    .setCenterX(1.75, 0, 0, 0)
    .setCenterY(-0.2, 0, 0, 0)
    .setTeeth(60)
    .setDir(-1)
    ;

  PIVOT = new Pin(pivotGear, 0.8);
  FULCRUM = new Pin(fulcrumGear, 0.8);
  PENDIST = new OSC(1.5, 0.5, 1, 0);
  PENOFF = new OSC(0.6, 0.5, 2, 0);


  //

  background(0);
  strokeCap(SQUARE);
}

void keyPressed() {
  if (key == ' ') {
    mode = (mode + 1)%2;
  }
  if (key == 'p' || key == 'P') {
    pause = !pause;
  }
}

void draw() {
  if (!pause) {
    translate(width/2, height/2);
    //println(frameRate);
    fill(255);
    stroke(255, 255, 255, 80);
    strokeWeight(2);

    /*
  if you want to watch the images be drawn slowly as if it was a real pen
     comment out from the (mode==0) loop the following:
     
     background(0);
     a_t = 0;
     pos_t++;
     
     and set num_steps to something small like 2
     
     Can also adjust speed and smoothness by messing with VEL and da_t above
     */

    int num_steps = 5000;

    if (mode == 0) {
      background(0);
      for (int i=0; i<num_steps; i++) {
        PVector pivot_pos = PIVOT.getPosition(a_t, pos_t);
        PVector fulcrum_pos = FULCRUM.getPosition(a_t, pos_t);
        PVector base_pos = BASE.getPosition(a_t, pos_t);

        // this rotates everything around the BASE gear 
        // instead of spinning the image like in the video
        PVector b2p = PVector.sub(pivot_pos, base_pos);
        PVector b2f = PVector.sub(fulcrum_pos, base_pos);
        float a = BASE.getAngle(a_t);
        b2p.rotate(-a).add(base_pos);
        b2f.rotate(-a).add(base_pos);

        PVector p2f = PVector.sub(b2f, b2p).normalize();
        PVector pen_base = PVector.add(b2p, PVector.mult(p2f, PENDIST.getVal(pos_t)));
        PVector pen_point = PVector.add(pen_base, PVector.mult(p2f, PENOFF.getVal(pos_t)).rotate(-PI/2));

        if (a_t == 0) {
          prev_point = pen_point;
        }

        line(pen_point.x, pen_point.y, prev_point.x, prev_point.y);  
        prev_point = pen_point;

        a_t += da_t;
      }
      a_t = 0;

      // Uncomment to save frames for a gif
      //if (pos_t < FRAMES) {
      //  saveFrame("/Frames/frame_###.tif");
      //}

      pos_t++;
    } else if (mode == 1) {  // GEAR VIEW MODE
      background(0);
      PVector pivot_pos = PIVOT.getPosition(a_t, pos_t);
      PVector fulcrum_pos = FULCRUM.getPosition(a_t, pos_t);
      PVector p2f = PVector.sub(fulcrum_pos, pivot_pos).normalize();
      PVector pen_base = PVector.add(pivot_pos, PVector.mult(p2f, PENDIST.getVal(pos_t)));
      PVector pen_point = PVector.add(pen_base, PVector.mult(p2f, PENOFF.getVal(pos_t)).rotate(-PI/2));

      line(pivot_pos.x, pivot_pos.y, fulcrum_pos.x, fulcrum_pos.y);
      line(pen_base.x, pen_base.y, pen_point.x, pen_point.y);
      noFill();
      circle(0, 0, 2*SCL);

      PIVOT.show();
      FULCRUM.show();

      fill(255, 0, 0);
      circle(0, 0, 10);

      fill(255, 255, 0);
      circle(pen_point.x, pen_point.y, 5);

      a_t += da_t/2;
      pos_t += 0.5;
    }
  }
}  
