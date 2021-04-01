/* //<>//

Based on: http://rainbowsmoke.hu/tech

- choose a cell from fillable_cells
- get avg color of neighbors
- find color that is closest to avg in the Octtree
- fill cell and remove color
- add neighboring cells to fillable_cells, giving each a weight according to 
      alignment with the flowfield

*/


PImage img;           // Reference image to extract colors from (should be placed in Data folder)
int g = 250;          // grid size (start small this takes some time)

// MAIN PARAMETERS
int col_dist = 1;     // distance over which avg color is calculates
int add_dist = 1;     // distance for new cells to get added to fillable_cells
int num_seeds = 1;    // initial cells filled before algorithm start
int num_nodes = 1;    // forceNodes created for to make flow field

/*
increasing the distances will make things slower, but changes the 
appearance significantly.

higher col_dist makes things more blurry and smooth gradients
higher add_dist mkes things more "grainy"

*/


Cell[] cells;         
ArrayList<Cell> fillable_cells;        // not yet filled cells that are in range
Cell chosen_cell = new Cell(0, 0, 0, 0, 0);   // Stores the current cell
float weight_total;
Octtree colors;
ForceNode[] nodes = new ForceNode[num_nodes];

void setup() {
  size(1000, 1000);
  img = loadImage("img1.jpg");
  img.loadPixels();
  INIT();
}

void INIT() {
  background(255);
  weight_total = 0;

  // Initializing forceNodes with random position
  // This will define the flowField
  for (int i=0; i<num_nodes; i++) {
    nodes[i] = new ForceNode(random(width), random(height));
  }

  // Initializing cells
  cells = new Cell[g*g];
  fillable_cells = new ArrayList<Cell>();
  float s = float(width)/g;

  for (int j=0; j<g; j++) {
    float y = j*s;
    for (int i=0; i<g; i++) {
      float x =i*s;
      Cell cell = new Cell(j*g + i, x, y, s, s);
      cell.setDir();
      cells[j*g + i] = cell;
    }
  }
  
  // Filling Octtree with colors from img  
  colors = new Octtree(-1, 256, -1, 256, -1, 256);

  for (int j=0; j<g; j++) {
    int y = int(img.height * float(j)/g); 
    for (int i=0; i<g; i++) {
      int x = int(img.width * float(i)/g); 
      color c = img.pixels[y*img.width + x];
      colors.insert(new Point(red(c), green(c), blue(c), colors));
    }
  }

  // Seeding initial points
  for (int i=0; i<num_seeds; i++) {
    
    //// Random seed positions
    //int rand_idx = (int) random(g*g);
    //Cell seed_cell = cells[rand_idx];
    
    // Looks better when seeds are centered on the nodes (assuming there are enough nodes)
    // (should probably make the weight function look backwards too not just forward)
    ForceNode node = nodes[i];
    Cell seed_cell = cells[(int)(node.pos.y/s)*g + (int)(node.pos.x/s)];

    if (seed_cell.filled) {  // dont pick same twice
      continue;
    }

    // Random "avg" color
    Point rand_point = new Point((int)random(255), (int)random(255), (int)random(255), colors);

    // search Octtree for nearest to rand_point
    Octtree _ot = colors.getSubOT(rand_point);
    Point seed_col = getNearest(colors, _ot, rand_point);
    seed_cell.p = seed_col;
    seed_cell.filled = true;
    seed_col.removeSelf();
    addNeighborsToArray(seed_cell, add_dist);
  }
}

void keyPressed() {
  if (key == ' ') {
    INIT();
    loop();
  }
  if (key == 's' || key == 'S') {
    int y = year();
    int m = month();
    int d = day();
    int h = hour();
    int n = minute();
    int s = second();
    String filename = "RainbowSmoke_" + Integer.toString(y) + Integer.toString(m) + Integer.toString(d) + Integer.toString(h) + Integer.toString(n) + Integer.toString(s) + ".png";
    save("Images/" + filename);
    println("Saved: " + filename);
  }
}


void draw() {

  noLoop();
  noStroke();

  float t1 = millis();

  for (int it=0; it<(g*g-num_seeds); it++) {   // for each cell

    // Pick random cell based on weighted random
    float rand = random(weight_total);
    for (int i=0; i<fillable_cells.size(); i++) {
      chosen_cell = fillable_cells.get(i);
      rand -= chosen_cell.weight;
      if (rand < 0) {
        fillable_cells.remove(i);
        break;
      }
    }

    if (chosen_cell.filled) { // must be a seed cell that got added, just ignore
      weight_total -= chosen_cell.weight;
      it--;
      continue;
    }

    Point avg = new Point(0, 0, 0, colors);
    int n = 0;
    for (int idx : chosen_cell.getNeighborIndicies(col_dist, g)) {
      Cell ncell = cells[idx];
      if (ncell.filled) {
        n++;
        avg.x += ncell.p.x;
        avg.y += ncell.p.y;
        avg.z += ncell.p.z;
      }
    }
    avg.x /= n;
    avg.y /= n;
    avg.z /= n;

    // The break conditions shouldnt ever happen, but the Octtree code must have some bugs still
    // that I havent fixed yet
    Octtree avg_ot = colors.getSubOT(avg);
    if (avg_ot == null) {
      println("Cant get SubOT");
      break;
    }
    Point nearest = getNearest(colors, avg_ot, avg);
    if (nearest != null) {
      chosen_cell.p = nearest;
      nearest.removeSelf();
    } else {
      println("Cant find Nearest");
      break;
    }
    
    chosen_cell.filled = true;
    weight_total -= chosen_cell.weight;
    addNeighborsToArray(chosen_cell, add_dist);
  }

  for (Cell cell : cells) {
    cell.show();
  }

  float t2 = millis();
  println("Time: ", t2-t1);
}
