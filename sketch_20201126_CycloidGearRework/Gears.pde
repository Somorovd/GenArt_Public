/*
  Im not reaslly familiar with java classes and abstract methods
 but I wanted the two gear types to be the "same" so that the 
 methods can all be called one after another in the 
 declaration. This works for me but maybe there are better ways.
 IDK.
 */

abstract class Gear {
  abstract PVector getPosition(float a_t, float p_t);
  abstract float getAngle(float a_t);
  abstract Gear addGear();
  abstract int getTeeth();
  abstract int getDir();
  abstract void show();
}

class AttachedGear extends Gear {

  /*    
   This class is for a gear that is attached to a fixed
   point on another gear. The rotation of the parent gear 
   changes the position of the AttachedGear.
   
   In the physical world, there would be a second gear
   concentric with the parent gear that is fixed 
   that the AttachedGear rotates about. 
   Go to 4:45 in the video linked in main tab for an example.
   See the top right gear.
   
   That type of setup is mimicked with setToothRatio()
   but all gears can be spun independently by using setVel()
   */


  Gear parent;
  PVector parent_pos;
  PVector current_pos;
  int teeth, dr_teeth;
  float vel, d;
  int dir = 1;  // direction of rotation. 

  AttachedGear(Gear _parent, int _dir) {
    parent = _parent;
    dir = _dir;
  }

  AttachedGear setTeethRatio(int _teeth, int _dr_teeth) {
    teeth = _teeth;

    // Honestly not sure if this is the correct equation.
    // It seems to work but I havent been able to fully
    // derive it to my satisfaction.
    // Its a coumpound gear, except it is also rotating about
    // the center gear.
    vel = 2 * VEL * _dr_teeth * BASETEETH / (teeth * parent.getTeeth());
    return this;
  }

  AttachedGear setVel(float _vel) {
    vel = _vel * VEL;
    return this;
  }

  // How far out this gear is from the center of the parent
  // gear as a percentage of parent gear radius
  // Could potentially be turned into an OSC as well
  AttachedGear setDistance(float _d) {
    d = _d*SCL/BASETEETH * parent.getTeeth();
    return this;
  }

  AttachedGear setDir(int _dir) {
    dir = _dir; 
    return this;
  }

  PVector getPosition(float a_t, float p_t) {
    parent_pos = parent.getPosition(a_t, p_t);
    float a = parent.getAngle(a_t);
    float x = parent_pos.x + d * cos(a);
    float y = parent_pos.y + d * sin(a);
    current_pos = new PVector(x, y);
    return current_pos;
  }

  float getAngle(float a_t) {
    return vel * a_t * dir;
  }

  int getTeeth() {
    return teeth;
  }

  int getDir() {
    return dir;
  }

  AttachedGear addGear() {
    // The gear attached to this one will have the same rotation by default
    return new AttachedGear(this, dir);
  }

  void show() {
    fill(255);
    noStroke();
    circle(current_pos.x, current_pos.y, 10);
    noFill();
    stroke(255, 255, 255, 100);
    circle(parent_pos.x, parent_pos.y, 2*d);
    parent.show();
  }
}

class FreeGear extends Gear {
  
  /*
    These gears serve as the base of the gear train.
    Their position is independent of any other gear.
    Mostly the same as attahced gear, except center
    must be specified and setTeeth() instead of
    setTeethRatio().
  */

  float vel;
  int teeth;
  int dir;

  OSC centerX;
  OSC centerY;  
  PVector current_pos;

  FreeGear setTeeth(int _teeth) {
    teeth = _teeth;
    vel = VEL * BASETEETH / teeth;
    return this;
  }

  FreeGear setVel(float _vel) {
    vel = _vel * VEL;
    return this;
  }

  FreeGear setCenterX(float val, float amp, int frq, float phs) {
    centerX = new OSC(val, amp, frq, phs);
    return this;
  }

  FreeGear setCenterY(float val, float amp, int frq, float phs) {
    centerY = new OSC(val, amp, frq, phs);
    return this;
  }

  FreeGear setDir(int _dir) {
    dir = _dir;
    return this;
  }

  PVector getPosition(float a_t, float p_t) {
    float x = centerX.getVal(p_t); 
    float y = centerY.getVal(p_t); 
    current_pos = new PVector(x, y);
    return current_pos;
  }

  float getAngle(float a_t) {
    return vel * a_t * dir;
  }

  int getTeeth() {
    return teeth;
  }

  int getDir() {
    return dir;
  }

  AttachedGear addGear() {
    return new AttachedGear(this, dir);
  }

  void show() {
    fill(0);
    stroke(255);
    circle(current_pos.x, current_pos.y, 10);
  }
}
