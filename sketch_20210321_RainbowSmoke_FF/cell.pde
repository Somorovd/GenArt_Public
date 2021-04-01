class Cell {

  int i;
  float x, y, w, h;
  boolean filled = false;
  boolean in_array = false;
  Point p;
  float weight = 0;

  PVector dir; 

  Cell (int _i, float _x, float _y, float _w, float _h) {
    i = _i;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }

  void setDir() {   // Sample the flow field here
    dir = getNetForce(new PVector(x, y)).normalize();  
  }

  // Get indicies of neighboring cells within distance n
  ArrayList<Integer> getNeighborIndicies(int n, int g) {
    ArrayList<Integer> arr = new ArrayList<Integer>();    
    int row = i/g;
    int col = i%g;

    for (int dx=-n; dx<=n; dx++) {
      for (int dy=-n; dy<=n; dy++) {
        if (dx == 0 && dy == 0) {
          continue;
        } else if (row + dy < 0 || row + dy >= g || col + dx < 0 || col + dx >= g) {
          continue;
        } else {
          arr.add((row + dy)*g + (col + dx));
        }
      }
    }
    return arr;
  }

  void show() {
    noStroke();
    if (p != null) {
      fill(p.x, p.y, p.z);
      rect(x, y, w, h);
    } else {
      fill(255, 0, 255);
    }
  }
  
  void showDir() { // visualize the flowfield if you like (not very clear on small cells)
    stroke(0);
    line(x+w/2, y+h/2, x+w/2 + dir.x*w/2, y+h/2+dir.y*w/2);
  }
}
