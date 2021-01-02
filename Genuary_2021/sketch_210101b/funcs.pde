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

class Rect {
  float x, y, w, h;
  color c;
  
  Rect(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  void setColor(color _c){
     c = _c; 
  }
}

Rect[] generateRects() {

  float b = 50;

  int n1 = 5;
  float g1 = 20;

  int n2 = 7;
  float g2 = 10;

  int n3 = 3;

  Rect[] rects = new Rect[n1*n2*n3];

  float[] level1 = partition(b, width-b - (n1-1)*g1, n1, 8, 80, 400);

  for (int i=0; i<level1.length-1; i++) {
    float w = level1[i+1] - level1[i];
    float x = level1[i] + g1*i;

    float[] level2 = partition(b, height-b - (n2-1)*g2, n2, 8, 20, 300);

    for (int j=0; j<level2.length-1; j++) {
      float h = level2[j+1] - level2[j];
      float y = level2[j] + g2*j;

      float[] level3;
      float g3 = 10;

      if (w > h) {
        g3 = min(g3, w*0.08);
        level3 = partition(x, x+w - 2*g3, n3, 7, w*.15, w*.7);
      } else {
        g3 = min(g3, h*0.08);
        level3 = partition(y, y+h - 2*g3, n3, 7, h*.15, h*.7);
      }

      for (int k=0; k<level3.length-1; k++) {
        Rect rect;
        if (w > h) {
          float _w = level3[k+1] - level3[k];
          float _x = level3[k] + g3*k;
          rect = new Rect(_x, y, _w, h);
        } else {
          float _h = level3[k+1] - level3[k];
          float _y = level3[k] + g3*k;
          rect = new Rect(x, _y, w, _h);
        }
        rects[i*n2*n3 + j*n3 + k] = rect;
      }
    }
  }

  return rects;
}
