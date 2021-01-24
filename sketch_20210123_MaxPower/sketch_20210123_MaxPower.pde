/*

Cycling through multiple sketches in the same project

*/

abstract class Sketch {
  abstract void init();
  abstract void show();
}

int SKETCH = 0;
Sketch[] sketches = {
  new sketch0(), 
  new sketch1()
};

void setup() {
  fullScreen(P3D);
  sketches[0].init();
}

void mouseClicked() {
  SKETCH = (SKETCH + 1) % sketches.length;
  sketches[SKETCH].init();
}

void draw() {
  sketches[SKETCH].show();
}
