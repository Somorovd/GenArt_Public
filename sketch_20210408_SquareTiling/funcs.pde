class Cell {
  int x, y, w, h;
  Cell(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void show() {
    rect(b + x*xspc, b + y*yspc, w*xspc, h*yspc);
  }
}

ArrayList<Integer> arrCopy(ArrayList<Integer> arr){
    ArrayList new_arr = new ArrayList();
    for (int i : arr){
      new_arr.add(i);
    }
    return new_arr;
}

ArrayList<Integer> arrShuffle(ArrayList<Integer> arr){
  ArrayList<Integer> new_arr = new ArrayList<Integer>();
  ArrayList<Integer> indicies = new ArrayList<Integer>();
  for (int i=0; i<arr.size(); i++){
     indicies.add(i); 
  }
  for (int i=0; i<arr.size(); i++){
     int idx = (int)random(indicies.size());
     new_arr.add(arr.get(indicies.get(idx)));
     indicies.remove(idx);
  }
  return new_arr;
}
