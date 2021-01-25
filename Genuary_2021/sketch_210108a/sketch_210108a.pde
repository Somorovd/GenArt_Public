/*

 For GENUARY 2021 : Day 8
 Prompt : Curves Only
 
 */

void setup() {
  size(800, 1000);
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
    String filename = "CurvesOnly" + Integer.toString(y) + Integer.toString(m) + Integer.toString(d) + Integer.toString(h) + Integer.toString(n) + Integer.toString(s) + ".png";
    save("Images/" + filename);
    println("Saved: " + filename);
  }
}

void draw() {
  noLoop();
  background(255);

  float b = -40;
  int num_points = 40;
  float h = 25;
  float w = (width-2*b)/(num_points);

  int bins = 13;
  int min = 1;
  int max = 10;
  int n = num_points - bins*min ;

  int it = 17;
  PVector[][] all_points = new PVector[it][bins+1];

  for (int j=-int(it/2); j<=int(it/2); j++) { 

    float mid = height/2 + j*2*h;
    float[] parts = partition(0, num_points, bins, n, min, max);

    stroke(200);
    for (int i=0; i<=num_points; i++) {
      float pct = float(i)/(num_points);
      float x = b + pct*(width-2*b);
      //line(x, mid + h, x, mid-h);
      //line(b, mid + h, width-b, mid + h);
      //line(b, mid - h, width-b, mid - h);
    }

    float[] ys = {h, -h};
    PVector[] points = new PVector[parts.length];

    stroke(255, 0, 0);
    strokeWeight(1);
    noFill();
    for (int i=0; i<parts.length; i++) {
      float x = b + parts[i]*w;
      float y = mid + ys[i%ys.length];
      //circle(x, y, 10);
      points[i] = new PVector(x, y);
    }

    all_points[j+int(it/2)] = points;
    strokeWeight(2);
    PVector[] ch = chaikin(points, 3);
    PVector[][] spacing = curveSpacing(ch, 10, true);  
    PVector[] spaced_points = spacing[0];
    //connect(spaced_points, false);

    fill(0);
    noStroke();
    for (PVector p : spaced_points) {
      //circle(p.x, p.y, 6);
    }
  }
  for (int i=0; i<all_points.length-1; i++) {
    PVector[] arr1 = all_points[i];
    PVector[] arr2 = all_points[i+1];

    PVector[] new_arr = new PVector[arr1.length];

    float kmax = 60;
    float spc = 10;//int(random(4, 12));
    
    for (int k=1; k<kmax; k++) {

      float pct = k/kmax;

      for (int j=0; j<arr1.length; j++) {
        new_arr[j] = PVector.add(PVector.mult(arr1[j], pct), PVector.mult(arr2[j], 1-pct));
      }

      PVector[] ch = chaikin(new_arr, 3);
      PVector[][] spacing = curveSpacing(ch, spc, false);  
      PVector[] spaced_points = spacing[0];


      color c = lerpColor(color(0, 255, 0), color(255, 0, 255), pct);
      fill(c);
      noStroke();
      //for (PVector p : spaced_points) {
      //  circle(p.x, p.y, 2);
      //}
      noFill();
      stroke(0, 0, 0, 70);
      strokeWeight(2);
      connect(spaced_points, false);
    }
  }
}
