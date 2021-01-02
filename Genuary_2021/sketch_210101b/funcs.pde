float[] partition(float x1, float x2, int bins, int n, float min, float max) {

  /*
  
   Increments a random bin n times. 
   Larger n values will tend towards all bins being equal in size.
   
   Bin sizes are clamped between min and max, and the sum of all bins 
   equals (x2 - x1).
   
   Return values are the incremental sums of bin sizes
   Example : for range 0-10 and bin sizes 1, 1, 5, 3
         -> returns {0, 1, 2, 7, 10}
   
   TODO:
     * Would be better if this dealt with percentages so that it would be more 
       general, but this works for now.
     * There is no check on the input parameters so it is possible to crash
       if the size contraints are impossible
   
   */

  float[] arr = new float[bins];

  // Available indexes within arr that can still be added to
  ArrayList<Integer> valid = new ArrayList<Integer>();

  // All bins initializes at the minimum size
  for (int i=0; i<bins; i++) {
    arr[i] = min;  
    valid.add(i);
  }

  // Remaining space is distributed in n separate instances
  float s = ((x2-x1)-min*bins)/n;

  for (int i=0; i<n; i++) {
    int v_id = int(random(valid.size()));  // random index within 'valid' array
    int j = valid.get(v_id);               // An index of a valid bin in 'arr'
    arr[j]+=s;

    // When a bin reaches max size it is no longer valid and will be removed
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

  void setColor(color _c) {
    c = _c;
  }
}

Rect[] generateRects(int n1, int n2, int n3, int g1, int g2, int g3, int b) {
  
  /* 
  
     Generates the main pattern of rectangles by partitioning 3 layers deep.
     Partition width of canvas, then each of those sections, and each of those.
     Returns an array of all the rectangles.
    
  */

  Rect[] rects = new Rect[n1*n2*n3];

  float[] level1 = partition(b, width-b - (n1-1)*g1, n1, 8, 80, 400);  
  // Ive hardcoded the last 3 values because these work nice and I didnt want 
  // a million input parameters.

  for (int i=0; i<level1.length-1; i++) {
    float w = level1[i+1] - level1[i];
    float x = level1[i] + g1*i;

    float[] level2 = partition(b, height-b - (n2-1)*g2, n2, 8, 20, 300);

    for (int j=0; j<level2.length-1; j++) {
      float h = level2[j+1] - level2[j];
      float y = level2[j] + g2*j;

      float[] level3;
      if (w > h) {
        level3 = partition(x, x+w - 2*g3, n3, 7, w*.15, w*.7);
      } else {
        level3 = partition(y, y+h - 2*g3, n3, 7, h*.15, h*.7);
      }

      for (int k=0; k<level3.length-1; k++) {
        Rect rect; 
        if (w > h) { // Adding some variety
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
