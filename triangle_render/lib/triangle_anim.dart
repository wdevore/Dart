class TriangleAnimation {
  // Triangle's position
  int x = 250, y = 200;

  // Initial vertices positions
  int x1 = 0;
  int y1 = 50;
  int x2 = 50;
  int y2 = 50;
  int x3 = 25;
  int y3 = 0;

  // Goofy simple animation vars
  int dir = 1;
  int dir2 = 1;
  int dir3 = 1;
  int xx = 75;
  int xx2 = 0;
  int xx3 = 100;

  void update() {
    // Transform vertices based on animation
    if (xx2 < -50) {
      dir2 = 2;
    } else if (xx2 > 100) {
      dir2 = -2;
    }
    xx2 += dir2;

    if (xx3 < 0) {
      dir3 = 1;
    } else if (xx3 > 100) {
      dir3 = -1;
    }
    xx3 += dir3;

    if (xx < -50) {
      dir = 1;
    } else if (xx > 100) {
      dir = -1;
    }
    xx += dir;
  }
}
