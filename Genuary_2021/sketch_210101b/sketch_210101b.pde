/*

For GENUARY 2021 : Day 1
Prompt : Triple Nested Loop

*/

void setup() {
  size(1200, 800);
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
    String filename = "RectPartitions" + Integer.toString(y) + Integer.toString(m) + Integer.toString(d) + Integer.toString(h) + Integer.toString(n) + Integer.toString(s) + ".png";
    save("Images/" + filename);
    println("Saved: " + filename);
  }
}

void draw() {

  noLoop();
  background(255);

  Rect[] rects1 = generateRects();
  Rect[] rects2 = generateRects();

  PGraphics pg = createGraphics(width, height);

  pg.beginDraw();
  pg.background(0);
  pg.noStroke();
  for (Rect r : rects1) {
    r.setColor(color(random(255))); 
    pg.fill(r.c);
    pg.rect(r.x, r.y, r.w, r.h);
  }
  pg.endDraw();

  pg.loadPixels();
  loadPixels();

  for (Rect r : rects2) {
    for (int i=0; i<r.w; i++) {
      for (int j=0; j<r.h; j++) {
        float x = r.x + i;
        float y = r.y + j;
        int idx = int(y)*width + int(x);

        float min = 0.2;
        float  max = 0.95;
        float pct = map(red(pg.pixels[idx]), 0, 255, min, max);
        pixels[idx] = (random(1) < pct) ? color(0) : color(255);
      }
    }
  }
  updatePixels();

  noFill();
  stroke(0);
  strokeWeight(2);
  for (Rect r : rects2) {
    rect(r.x, r.y, r.w, r.h);
  }
}
