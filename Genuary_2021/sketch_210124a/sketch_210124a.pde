/*

 Genuary Days 23-25
 23: #264653 #2a9d8f #e9c46a #f4a261 #e76f51, no gradients
 24: 500 lines
 25: make a grid of permutations of something
 
 */

color DARK = color(38, 70, 83);
color[] palette = {color(42, 157, 143), color(233, 196, 106), color(244, 162, 97), color(231, 111, 81)};


void setup() {
  // originally this was made at size 600x750,
  // now everything has been scaled up by (800./600)
  size(800, 1000);
  strokeCap(PROJECT);
}  

void keyPressed() {
  if (key == ' ') {
    loop();
  }
  if (key == 's' || key == 'S') {
    int y = year();
    int m = month();
    int d = day();
    int h = hour();
    int n = minute();
    int s = second();
    String filename = "DotsBoxes" + Integer.toString(y) + Integer.toString(m) + Integer.toString(d) + Integer.toString(h) + Integer.toString(n) + Integer.toString(s) + ".png";
    save("Images/" + filename);
    println("Saved: " + filename);
  }
}

void draw() {
  noLoop();
  background(255);

  int small_grid = 5;                     // grid of dots per game
  PVector large_grid = new PVector(4, 5); // grid of games

  Game[] games = new Game[(int)large_grid.x*(int)large_grid.y];

  float b = 60*(800./600); // edge border
  float gap_pct = 0.4;     

  // width and height of each game
  float w = width - 2*b;
  w /= large_grid.x + (large_grid.x-1)*gap_pct;
  float h = height - 2*b;
  h /= large_grid.y + (large_grid.y-1)*gap_pct;

  for (int i=0; i<large_grid.x; i++) {
    float x0 = b + w*(1+gap_pct)*i;
    for (int j=0; j<large_grid.y; j++) {
      float y0 = b + h*(1+gap_pct)*j;
      games[j*(int)large_grid.x + i] = new Game(x0, y0, i, j, w, h, small_grid);
    }
  }

  for (Game g : games) {
    g.playGame(25); // for 20 games with 25 lines each there will be 500 lines
    g.showDots();
    g.showBoxes();
    g.showLines();

    if ((g.gx%2 == 0 && g.gy%2 == 0) || (g.gx%2 == 1 && g.gy%2 == 1)) {
      stroke(DARK);
      strokeWeight(2);
      noFill();
      rect(g.x0 - w*gap_pct/3, g.y0 - h*gap_pct/3, w + 2*w*gap_pct/3, h + 2*h*gap_pct/3);
    }
  }
}
