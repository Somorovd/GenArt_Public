float getWeight(float a, float wmin, float wmax) {
  // Just a random function I made.
  // In polar coordinates its like a long teardrop.
  // large weight to a=0, very low to a=PI
  float _a = map(abs(a), 0, PI, 0, PI/4);
  return map(pow(1 + sin(_a - PI/2), 3), 0, pow(1 + sin(-PI/4), 3), wmin, wmax);
}

Point getNearest(Octtree main_ot, Octtree sub_ot, Point p) {
  /* 
    sub_ot is the smallest undivided cell that the point fits it
    therefore there is another point in the sub_ot
    furthest apart they can be is in opposite corners - dim*sqrt3
    so we then query everything in this distance to find any point nearer in other cells
    (really a query sphere would be better than rect, but its probably not a huge deal, idk)
  */
  float dx = (sub_ot.x2 - sub_ot.x1)*sqrt(3);
  float dy = (sub_ot.y2 - sub_ot.y1)*sqrt(3);
  float dz = (sub_ot.z2 - sub_ot.z1)*sqrt(3);

  ArrayList<Point> found = new ArrayList<Point>();
  main_ot.query(p.x-dx, p.x+dx, p.y-dy, p.y+dy, p.z-dz, p.z+dz, found);

  float min_dist = sq(dx)+sq(dy)+sq(dz);
  Point nearest = null;
  for (Point _p : found) {
    float d = dist(p.x, p.y, p.z, _p.x, _p.y, _p.z);
    if (d < min_dist) {
      min_dist = d;
      nearest = _p;
    }
  }
  return nearest;
}

void addNeighborsToArray(Cell cell, int d) {
  for (int idx : cell.getNeighborIndicies(d, g)) {
    Cell ncell = cells[idx];
    if (ncell.filled) {
      continue;
    }
    PVector center1 = new PVector(cell.x+cell.w/2, cell.y+cell.h/2);
    PVector center2 = new PVector(ncell.x+ncell.w/2, ncell.y+ncell.h/2);
    PVector dir = PVector.sub(center1, center2);
    float a = PVector.angleBetween(dir, cell.dir);
    float weight = getWeight(a, 0.1, 50);
    ncell.weight += weight;
    weight_total += weight;
    if (!ncell.in_array) {
      fillable_cells.add(ncell);
      ncell.in_array = true;
    }
  }
}

PVector getNetForce(PVector pos) {
  PVector net = new PVector(0, 0);
  for (ForceNode node : nodes) {
    net.add(node.getForce(pos));
  }
  return net;
}
