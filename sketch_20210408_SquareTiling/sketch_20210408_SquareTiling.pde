// SQUARE TILINGS

int gx = 30;
int gy = 30;
float b = 20; // edge border
int[] sizes = {5, 4, 3, 2, 1}; // Keep this is descending order otherwise the small one will take space from the big

float xspc, yspc;
int[] max_sizes;
ArrayList<Integer> not_visited;
ArrayList<Cell> cells;

void setup() {
  size(800, 800);
}

void keyPressed() {
  if (key == ' ') {  // PRESS SPACE FOR NEW
    loop();
  }
}


void draw() {
  noLoop();
  background(255);
  stroke(0);

  max_sizes = new int[gx*gy];
  not_visited = new ArrayList<Integer>();
  cells = new ArrayList<Cell>();

  xspc = (width-2*b)/(gx);
  yspc  = (height-2*b)/(gy);

  // each cell is defined by the top left corner
  // max_size depends on distance to the right and down
  for (int j=0; j<gy; j++) {
    for (int i=0; i<gx; i++) {
      max_sizes[j*gx + i] = min(gx-i, gy-j);
      not_visited.add(j*gx + i);
    }
  }

  not_visited = arrShuffle(not_visited);

  for (int s : sizes) {
    for (int i=0; i<not_visited.size(); i++) {
      int idx = not_visited.get(i);
      int ms = max_sizes[idx];
      int x = idx%gx;
      int y = idx/gx;


      if (ms < s && ms > 0) { // available spot, but doesnt fit
        continue;
      } else {
        not_visited.remove(i);
        i--;
        if (ms <= 0) {
          continue;
        }
      }

      Cell cell = new Cell(x, y, s, s);
      cells.add(cell);
      for (int _x=0; _x<x+s; _x++) {
        for (int _y=0; _y<y+s; _y++) {
          max_sizes[_y*gx + _x] = min(max_sizes[_y*gx + _x], max(x-_x, y-_y));
        }
      }
    }
  }

  for (Cell cell : cells) {
    fill(random(255), random(255), random(255), 50);
    cell.show();
  }
}
