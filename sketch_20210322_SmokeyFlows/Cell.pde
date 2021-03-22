class Cell {

  int i;
  float x, y, w, h;

  float a = 0;

  boolean used = false;
  boolean in_array = false;

  Cell (int _i, float _x, float _y, float _w, float _h) {
    i = _i;
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }

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

  PVector getDir(float mag) {
    return new PVector(1, 0).setMag(mag).rotate(a);
  }

  void show() {
    PVector dir = new PVector(1, 0).setMag(sqrt(w*w+h*h)/2).rotate(a);
    line(x+w/2, y + h/2, x+w/2+dir.x, y+h/2+dir.y);
  }
}
