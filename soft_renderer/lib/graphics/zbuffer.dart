class ZBuffer {
  late List<double> z;
  int width = 0;
  int height = 0;
  int zsize = 0;

  void size(int w, int h) {
    width = w;
    height = h;
    zsize = w * h;
    reset();
  }

  void reset() {
    z = List.filled(zsize, -1e30);
  }

  int getIndex(int c, int r) {
    if (r > height) return -1;
    int index = (r - 1) * width + c;
    return index;
  }

  // -1 = pixel is beyond screen
  //  0 = pixel was farther away and ignored
  //  1 = pixel is closer and should be entered into framebuffer and zbuffer
  //  2 = pixel is exact/(on top) and was ignored
  int setCell(int col, int row, double zv) {
    int i = getIndex(col, row);
    if (i > zsize - 1 || i < 0) return -1;
    return setCellByIndex(i, zv);
  }

  int setCellByIndex(int i, double zv) {
    int status = 0;

    if (i > zsize - 1) return -1;

    if (zv < z[i]) {
      //////////////////////////////////
      // pixel farther away
      //////////////////////////////////
      status = 0;
    } else if (zv > z[i]) {
      //////////////////////////////////
      // pixel closer
      //////////////////////////////////
      z[i] = zv;
      status = 1;
    } else if (zv == z[i]) {
      //////////////////////////////////
      // pixel same distance
      //////////////////////////////////
      status = 2;
    }
    return status;
  }
}
