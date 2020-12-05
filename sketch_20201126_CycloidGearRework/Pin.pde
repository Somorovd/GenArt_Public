class Pin {

  /*
    Essentially an AttachedGear of 0 radius.
   Perhaps redundant, but I feel like it makes 
   the setup more intuitive.
   */

  Gear parent;
  OSC r;
  PVector current_pos;
  PVector parent_pos;

  Pin(Gear _parent, float val, float amp, int frq, float phs) {
    parent = _parent;

    val *= float(parent.getTeeth())/BASETEETH;
    amp *= float(parent.getTeeth())/BASETEETH;
    r = new OSC(val, amp, frq, phs);
  }

  PVector getPosition(float a_t, float p_t) {
    parent_pos = parent.getPosition(a_t, p_t);
    float a = parent.getAngle(a_t);
    float x = parent_pos.x + r.getVal(p_t)*cos(a);
    float y = parent_pos.y + r.getVal(p_t)*sin(a);
    current_pos = new PVector(x, y);
    return current_pos;
  }

  void show(float p_t) {
    noStroke();
    fill(255, 0, 0);
    circle(current_pos.x, current_pos.y, 5);
    noFill();
    stroke(255, 255, 255, 100);
    circle(parent_pos.x, parent_pos.y, 2*r.getVal(p_t));
    parent.show(p_t);
  }
}
