class sketch1 extends Sketch {

  int total_frames = 200;
  int counter;

  float a1, a2, a3;
  float r, s;
  color c; 

  float rmin = -100;
  float rmax = 400;
  float smin = 5;
  float smax = 50;

  void init() {
    background(0);
    init2();
  }

  void init2() {
    c = color(random(255), random(255), random(255));
    fill(c);
    noStroke();

    counter = 0;
    a2 = random(2*PI);
    a3 = random(2*PI);
  }

  void show() {
    float pct = float(counter)/total_frames;
    a1 = pct * TWO_PI;
    r = map(sin(a1 + a2), -1, 1, rmin, rmax);
    s = map(sin(a1 + a3), -1, 1, smin, smax);  

    float x = width/2 + r*cos(a1);
    float y = height/2 + r*sin(a1);

    circle(x, y, s);

    counter = (counter + 1) % total_frames;
    if (counter == 0) {
      init2();
    }
  }
}
