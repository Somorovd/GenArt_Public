
int g = 80;
Cell[] cells = new Cell[g*g];

int num_particles = 2500;
Particle[] particles = new Particle[num_particles];
float rot, vlim, fmag, sd_pct; 


void setup() {
  size(800, 800);

  float w = float(width)/g;
  float h = float(height)/g;

  ArrayList<Float> remaining_angles = new ArrayList<Float>();
  ArrayList<Cell> neighbor_cells = new ArrayList<Cell>();

  // THESE ARE THE MAIN CONTROL VARIABLES
  rot = 2*PI*0.0006;     // how fast the field rotates (constant, but could be interesting to have variable)
  vlim = 1.0;            // max velocity of particles
  fmag = 0.08;           // magnitude of force applied by field on particles
  sd_pct = 0.012;        // percent of cells that are seed cells  
  
  // larger fmag keeps things tighter, smaller makes things wispier
  // larger rot makes more defined loops
  // havent really messed around with vlim


  // initializing cells
  for (int j=0; j<g; j++) {
    float y = j*h;
    for (int i=0; i<g; i++) {
      float x = i*w;
      cells[j*g + i] = new Cell(j*g + i, x, y, w, h);
    }
  }
  // initializing angle values
  for (int i=0; i<g*g; i++) {
    remaining_angles.add(2*PI/(g*g) * i);
  }
  // seeding
  int num_seeds = int(g*g*sd_pct);
  for (int i=0; i<num_seeds; i++) {
    int rand_cell_idx = (int)random(g*g);
    Cell cell = cells[rand_cell_idx];
    if (cell.used) { // just in case pick same cell twice
      continue;
    }
    int rand_a_idx = (int)random(remaining_angles.size());
    float a = remaining_angles.get(rand_a_idx);

    cell.a = a;
    cell.used = true;
    remaining_angles.remove(rand_a_idx);

    for (int idx : cell.getNeighborIndicies(1, g)) {
      Cell ncell = cells[idx];
      if (!(ncell.used || ncell.in_array)) {
        ncell.in_array = true;
        neighbor_cells.add(ncell);
      }
    }
  }

  for (int i=0; i<(g*g-num_seeds); i++) {
    int rand_idx = (int)random(neighbor_cells.size());
    Cell cell = neighbor_cells.get(rand_idx);
    neighbor_cells.remove(rand_idx);

    if (cell.used) { // just in case
      continue;
    }

    // calculating average angle of neighboring cells
    float a_avg = 0;
    int n = 0;
    for (int idx : cell.getNeighborIndicies(1, g)) {
      Cell ncell = cells[idx];
      if (ncell.used) {
        a_avg += ncell.a;
        n++;
      } else if (!ncell.in_array) {
        ncell.in_array = true;
        neighbor_cells.add(ncell);
      }
    }
    a_avg /= n; // n should always be greater than 0

    // finding nearest angle still available
    float min_dist = 3*PI;
    int closest_idx = -1;
    for (int j=0; j<remaining_angles.size(); j++) {
      float a = remaining_angles.get(j);
      float d = abs(a - a_avg);
      if (d < min_dist) {
        min_dist = d;
        closest_idx = j;
      }
    }

    cell.a = remaining_angles.get(closest_idx);
    cell.used = true;
    remaining_angles.remove(closest_idx);
  }

  background(255);
  //stroke(200, 0, 0);
  //for (Cell cell : cells) {
  //  cell.show();
  //}

  for (int i=0; i<num_particles; i++) {
    particles[i] = new Particle(new PVector(random(width), random(height)), vlim);
  }
}


boolean pause = false;

void keyPressed() {
  if (key == 'p') {
    pause = !pause;
    if (pause) {
      noLoop();
    } else {
      loop();
    }
  }
}

void draw() {
  strokeWeight(1);
  stroke(0, 0, 0, 3);

  for (Cell cell : cells) {
    cell.a = (cell.a + rot)%(2*PI);
  }  

  for (Particle p : particles) {
    int row = constrain(int(p.pos.y/(float(height)/g)), 0, g-1);
    int col = constrain(int(p.pos.x/(float(width)/g)), 0, g-1);
    Cell cell = cells[row*g + col];
    p.applyForce(cell.getDir(fmag));
    p.update();
    p.show();
  }
}
