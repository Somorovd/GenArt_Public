class sketch0 extends Sketch {

  int total_frames = 480;
  int counter;

  void init() {
    counter = 0;
    frameRate(60);
    background(127.5);
    strokeWeight(5);
    noFill();
  }

  void show() {
    float percent = float(counter) / 240;
    render(percent);
    counter++;
  }

  void render(float percent) {
    stroke(map((sin(percent*TWO_PI)), -1, 1, 20, 235), map((sin(percent*TWO_PI)), -1, 1, 20, 100));
    translate(width/2, height/2);
    float angle = percent*PI;
    rotateX(sin(angle));
    rotateY(cos(angle));
    rotateZ(map(mouseX*0.01, 0, 5, 0, PI));
    scale(map((sin(percent*HALF_PI)), -1, 1, 1, 2));
    beginShape();
    vertex(-100, 100, 100);
    vertex(-100, -100, 100);
    vertex(0, 0, 100);
    vertex(100, -100, 100);
    vertex(100, 100, 100);
    vertex(100, 0, 100);
    vertex(100, 0, -100);    
    vertex(100, -100, -100);
    vertex(100, 100, -100);
    vertex(0, 0, -100);
    vertex(-100, 100, -100);
    vertex(-100, -100, -100);
    vertex(-100, 0, -100);
    vertex(-100, 0, 100);   
    endShape();
  }
}
