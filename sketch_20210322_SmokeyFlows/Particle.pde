class Particle {

  PVector pos = new PVector(0, 0);
  PVector ppos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  PVector acc = new PVector(0, 0);

  float vlimit = 1;

  float max_dist = 1500;
  float dist_travelled = 0;

  Particle(PVector _p, float _vlim) {
    pos = _p;
    ppos = _p;
    vlimit = _vlim;
  }

  void update() {
    ppos = pos.copy();
    vel.add(acc);
    vel.limit(vlimit);
    pos.add(vel);
    acc.mult(0);

    // pac-man screen looping. 
    // Note that flow field is not continuous over the edges so sometimes particles bunch up there
    if (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height) {
      pos.x = (pos.x + 2*width)%width;
      pos.y = (pos.y + 2*height)%height;
      ppos = pos.copy();
    }

    //// This can get the points out of 'wells' but causes things to look a little messier. stylistic choice.
    //dist_travelled += PVector.dist(pos, ppos);
    //if (dist_travelled > max_dist) {
    //  reset();
    //}
  }

  void applyForce(PVector force) {
    acc.add(force);
  }

  void reset() {
    pos = new PVector(random(width), random(height));
    ppos = pos.copy();
    dist_travelled = 0;
    vel = new PVector(0, 0);
  }

  void show() {
    line(pos.x, pos.y, ppos.x, ppos.y);
  }
}
