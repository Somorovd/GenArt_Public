class ForceNode {
  PVector pos;
  float a = 180 + random(-90, 90);  // 180 points straight out, 0 points in
  float mag = random(30);

  ForceNode(float _x, float _y) {
    pos = new PVector(_x, _y);
  }

  PVector getForce(PVector p) {
    PVector force = PVector.sub(pos, p);
    force.setMag(mag/sq(force.mag()/1000));
    force.rotate(radians(a));
    return force;
  }
}
