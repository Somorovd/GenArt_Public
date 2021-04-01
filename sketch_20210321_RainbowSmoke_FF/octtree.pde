class Point {
  float x, y, z;
  Octtree main_ot, sub_ot;
  int dup = 1;

  Point(float _x, float _y, float _z, Octtree _ot) {
    x = _x; 
    y = _y;
    z = _z;
    main_ot = _ot;
  }

  void setOT(Octtree _ot) {
    sub_ot = _ot;
  }

  boolean equals(Point other) {
    return (x == other.x && y == other.y && z == other.z);
  }

  void removeSelf() {
    sub_ot.remove();
  }
}

class Octtree {
  
  /*
  
  if unfamiliar with tree structure see: https://www.youtube.com/watch?v=OJxEcs0w_kE
  as that is the base for this code
  
  */

  float x1, x2, y1, y2, z1, z2;
  boolean divided = false;
  Octtree parent = null;
  int contains = 0;

  Point point = null;
  Octtree fnw, fne, fse, fsw, bnw, bne, bse, bsw;

  Octtree(float _x1, float _x2, float _y1, float _y2, float _z1, float _z2) {
    x1 = _x1;
    x2 = _x2;
    y1 = _y1;
    y2 = _y2;
    z1 = _z1;
    z2 = _z2;
  }

  void subdivide() {
    float x_mid = (x2+x1)/2;
    float y_mid = (y2 + y1)/2;
    float z_mid = (z2 + z1)/2;
    fnw = new Octtree(x1, x_mid, y1, y_mid, z1, z_mid);
    fne = new Octtree(x_mid, x2, y1, y_mid, z1, z_mid);
    fse = new Octtree(x_mid, x2, y_mid, y2, z1, z_mid);
    fsw = new Octtree(x1, x_mid, y_mid, y2, z1, z_mid);
    bnw = new Octtree(x1, x_mid, y1, y_mid, z_mid, z2);
    bne = new Octtree(x_mid, x2, y1, y_mid, z_mid, z2);
    bse = new Octtree(x_mid, x2, y_mid, y2, z_mid, z2);
    bsw = new Octtree(x1, x_mid, y_mid, y2, z_mid, z2);

    divided = true;

    Octtree[] children = {fnw, fne, fse, fsw, bnw, bne, bse, bsw};
    for (Octtree ot : children) {
      ot.parent = this;
    }
    for (Octtree ot : children) {
      if (ot.insert(point)) {
        break;
      }
    }
    point = null;
  }

  boolean insert(Point p) {
    if (!(p.x >= x1 && p.x < x2 && p.y >= y1 && p.y < y2 && p.z >= z1 && p.z < z2)) {
      return false;
    } 

    contains++;

    if (point == null && !divided) {
      point = p;
      p.setOT(this);
    } else {

      if (point != null) {
        if (point.equals(p)) {
          point.dup++;
          p.dup = point.dup;
          p.sub_ot = point.sub_ot;
          return true;
        }
      }

      if (!divided) {
        subdivide();
      }

      Octtree[] children = {fnw, fne, fse, fsw, bnw, bne, bse, bsw};
      for (Octtree ot : children) {
        if (ot.insert(p)) {
          break;
        }
      }
    }

    return true;
  }

  // Find the smallest undivided cell that this points would fit in
  // Does not actually insert the point
  Octtree getSubOT(Point p) {
    if (!(p.x >= x1 && p.x < x2 && p.y >= y1 && p.y < y2 && p.z >= z1 && p.z < z2)) {
      return null;
    } 

    if (!divided) {
      if (contains > 0) {
        return this;
      } else {
        return null;
      }
    } else {
      Octtree[] children = {fnw, fne, fse, fsw, bnw, bne, bse, bsw};
      for (Octtree ot : children) {
        Octtree _ot = ot.getSubOT(p);
        if (_ot != null) {
          return _ot;
        }
      }
    }
    return this;
  }

  void remove() {
    point.dup--;
    contains--;

    Octtree curr_ot = this;
    Octtree nearest_parent = null;


    while (curr_ot.parent != null) {
      curr_ot = curr_ot.parent;
      curr_ot.contains--;
      if (nearest_parent == null && curr_ot.contains > 1) {
        nearest_parent = curr_ot;
      }
    }

    if (point.dup == 0) {
      point = null;

      ArrayList<Point> found = new ArrayList<Point>();

      // if null, then there is only one point left
      // curr_ot defaults to the largest bounding OT
      if (nearest_parent != null) {
        curr_ot = nearest_parent;
      } 
      curr_ot.query(curr_ot.x1, curr_ot.x2, curr_ot.y1, curr_ot.y2, curr_ot.z1, curr_ot.z2, found);
      curr_ot.point = null;
      curr_ot.divided = false;
      curr_ot.contains = 0;
      //println(found.size(), ' ');
      for (Point p : found) {
        curr_ot.insert(p);
      }
    }
  }

  void query(float _x1, float _x2, float _y1, float _y2, float _z1, float _z2, ArrayList<Point> found) {

    // check overlapping rects
    if ( x1 > _x2 || x2  < _x1 || y1 > _y2 || y2 < _y1 || z1 > _z2 || z2 < _z1) { 
      return;
    }

    if (!divided) {
      if (point != null) {
        if (point.x >= _x1 && point.x < _x2 && point.y >= _y1 && point.y < _y2 && point.z >= _z1 && point.z < _z2) {
          found.add(point);
        }
      }
    } else {
      Octtree[] children = {fnw, fne, fse, fsw, bnw, bne, bse, bsw};
      for (Octtree ot : children) {
        ot.query(_x1, _x2, _y1, _y2, _z1, _z2, found);
      }
    }
  }
}
