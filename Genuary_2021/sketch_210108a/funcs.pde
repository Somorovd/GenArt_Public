float[] partition(float x1, float x2, int bins, int n, float min, float max) {

  float[] arr = new float[bins];
  ArrayList<Integer> valid = new ArrayList<Integer>();
  for (int i=0; i<bins; i++) {
    arr[i] = min;  
    valid.add(i);
  }

  float s = ((x2-x1)-min*bins)/n;

  for (int i=0; i<n; i++) {
    int v_id = int(random(valid.size()));
    int j = valid.get(v_id);
    arr[j]+=s;
    if (arr[j] > max-s) {
      valid.remove(v_id);
    }
  }

  float[] ends = new float[bins+1];
  ends[0] = x1;
  for (int i=1; i<bins; i++) {
    ends[i] = ends[i-1] + arr[i];
  }
  ends[bins] = x2;

  return ends;
}

PVector[] chaikin(PVector[] p_points, int iter) {
  for (int it=0; it<iter; it++) {
    PVector[] qr_points = new PVector[2*(p_points.length-1)+2];
    for (int i=0; i<p_points.length-1; i++) {
      PVector p1 = p_points[i%p_points.length];
      PVector p2 = p_points[(i+1)%p_points.length];
      PVector d = PVector.sub(p2, p1);
      PVector q = PVector.add(p1, PVector.mult(d, 0.25));
      PVector r = PVector.add(p1, PVector.mult(d, 0.75));
      qr_points[2*i+1] = q;
      qr_points[2*i+2] = r;
    }
    qr_points[0] = p_points[0];
    qr_points[qr_points.length-1] = p_points[p_points.length-1];
    p_points = qr_points;
  }
  return p_points;
}

void connect(PVector[] points, boolean close) {
  beginShape();
  for (PVector p : points) {
    vertex(p.x, p.y);
  }
  if (close) {
    endShape(CLOSE);
  } else {
    endShape();
  }
}

PVector[][] curveSpacing(PVector[] points, float spacing, boolean fit) {    
  float total_length = 0;
  for (int i=0; i<points.length-1; i++) {
    PVector p1 = points[i];
    PVector p2 = points[i+1];
    total_length += dist(p1.x, p1.y, p2.x, p2.y);
  }

  int num_points = round(total_length/spacing);

  if (fit) {
    spacing += (total_length - num_points*spacing)/num_points;
  }

  PVector[] spaced_points = new PVector[num_points+1];
  spaced_points[0] = points[0];
  PVector [] slopes = new PVector[num_points+1];
  slopes[0] = PVector.sub(points[1], points[0]);

  int idx = 0;
  PVector p1 = points[0];
  PVector p2 = points[1];
  PVector p = p1; // keeps track of where previous spaced point is

  total_length = 0;
  for (int i=0; i<num_points; i++) {
    float d1 = 0;
    float d2 = 0;
    p1 = p;
    while (d2<spacing) {
      d1 = d2;
      d2 += dist(p1.x, p1.y, p2.x, p2.y);
      if (d2 < spacing && idx+1<=points.length-2) {
        // points wont change if the limit is reached so loop will 
        // start over with the last points
        idx++;
        p1 = points[idx];
        p2 = points[idx+1];
      }
    }
    // if end of the curve not yet reached
    float pct = (spacing-d1)/(d2-d1);
    p = PVector.lerp(p1, p2, pct);
    spaced_points[i+1] = p;
    slopes[i+1] = PVector.sub(p2, p1);
  }
  
  spaced_points[spaced_points.length-1] = points[points.length-1];
  slopes[slopes.length-1] = PVector.sub(points[points.length-2], points[points.length-1]);
  
  PVector[][] pair = {spaced_points, slopes};
  
  return pair;
}
