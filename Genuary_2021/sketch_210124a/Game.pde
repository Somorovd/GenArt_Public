class Game {
  
  // was going to actually play by the rules of the dots and boxes game, 
  // but it was easier not to...

  float x0, y0, w, h;
  int gx, gy, n;

  PVector[] dots;
  Box[] boxes;
  ArrayList<Integer> valid_idx = new ArrayList<Integer>(); // indicies of uncompleted boxes
  ArrayList<LN> lines = new ArrayList<LN>();

  color c1, c2;

  Game(float _x0, float _y0, int _gx, int _gy, float _w, float _h, int _n) {
    x0 = _x0;
    y0 = _y0; 
    gx = _gx;
    gy = _gy;
    w = _w;
    h = _h;
    n = _n;  

    dots = new PVector[n*n];
    getDots();
    boxes = new Box[(n-1)*(n-1)];
    getBoxes();
    
    c1 = palette[(int)random(palette.length)];
    c2 = palette[(int)random(palette.length)];
  }

  void getDots() {
    for (int i=0; i<n; i++) {
      float y = y0 + h/(n-1) * i;
      for (int j=0; j<n; j++) {
        float x = x0 + w/(n-1) * j;
        dots[i*n + j] = new PVector(x, y);
      }
    }
  }

  void getBoxes() {
    for (int i=0; i<n-1; i++) {
      float y = y0 + h/(n-1) * i;
      for (int j=0; j<n-1; j++) {
        float x = x0 + w/(n-1) * j;
        int idx = i*(n-1) + j;
        boxes[idx] = new Box(x, y, w/(n-1), h/(n-1));
        valid_idx.add(idx);
      }
    }
  }

  void playGame(int steps) {
    for (int i=0; i<steps; i++) {

      int idx_idx = (int)random(valid_idx.size());
      int idx = valid_idx.get(idx_idx);
      Box b = boxes[idx];

      if (b.getSum() == 0) { 
        // if box is completed, remove
        valid_idx.remove(idx_idx);
        i--;
        continue;
      } else {
        // choose a side to draw a line on
        int side = b.getNotChosen();
        lines.add(b.sides[side]);

        int x = idx%(n-1);
        int y = idx/(n-1);

        // indicate choice on both boxes that share the edge
        // or just one of not sharing
        
        b.not_chosen[side] = 0;
        
        Box _b = null; // neighbor box
        int _idx = -1;
        if (side == 0 && y > 0) {
          _idx = idx-(n-1);
          _b = boxes[_idx];
        } else if (side == 2 && y < (n-2)) {
          _idx = idx + (n-1);
          _b = boxes[_idx];
        } else if (side == 1 && x < (n-2)) {
          _idx = idx+1;
          _b = boxes[_idx];
        } else if (side == 3 && x > 0) {
          _idx = idx-1;
          _b = boxes[_idx];
        }

        if (_b != null) {
          int _side = (side+2)%4;
          _b.not_chosen[_side] = 0;
        }
      }
    }
  }

  void showDots() {
    fill(DARK);
    noStroke();
    for (PVector p : dots) {
      circle(p.x, p.y, 2*(800./600)*2);
    }
  }

  void showBoxes() {
    noStroke();
    for (Box b : boxes) {
      if (b.getSum() == 0) {
        //color c = random(1) > 0.5 ? c1 : c2;
        color c = palette[(int)random(palette.length)];
        fill(c);
        rect(b.x, b.y, b.w, b.h);
      }
    }
  }

  void showLines() {
    stroke(DARK);
    strokeWeight(10*(800./600));
    for (LN ln : lines) {
      line(ln.p1.x, ln.p1.y, ln.p2.x, ln.p2.y);
    }
  }
}

class LN {
  PVector p1, p2;
  LN(PVector _p1, PVector _p2) {
    p1 = _p1;
    p2 = _p2;
  }
}

class Box {

  float x, y, w, h;
  PVector tl, tr, br, bl;
  LN[] sides = new LN[4];

  int[] not_chosen = {1, 1, 1, 1};

  Box(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;

    tl = new PVector(x, y);
    tr = new PVector(x+w, y);
    br = new PVector(x+w, y+h);
    bl = new PVector(x, y + h);

    sides[0] = new LN(tl, tr);
    sides[1] = new LN(tr, br);
    sides[2] = new LN(br, bl);
    sides[3] = new LN(bl, tl);
  }

  int getNotChosen() {
    ArrayList<Integer> arr = new ArrayList<Integer>();
    for (int i=0; i<4; i++) {
      if (not_chosen[i] == 1) {
        arr.add(i);
      }
    }
    return arr.get((int)random(arr.size()));
  }

  int getSum() {
    int sum = 0; 
    for (int i=0; i<4; i++) {
      sum += not_chosen[i];
    }
    return sum;
  }
}
