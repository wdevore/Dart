class Edge {
  // Vertex indices into the ITriangle
  int xP = 0, yP = 0, xQ = 0, yQ = 0;
  int yBot = 0;
  double zP = 0.0, zQ = 0.0;

  int x = 0, y = 0, d = 0;
  int yInc = 0, xInc = 0, dx = 0, dy = 0;
  int m = 0, c = 0;

  double get z1 => zP;
  double get z2 => zQ;

  void set(int xP, yP, xQ, yQ, double zP, zQ) {
    // Note: the larger Y value is at the "bottom" or lower on the display
    // if +Y axis is downward.
    if (yP > yQ) {
      yBot = yP;
    } else {
      yBot = yQ;
    }

    this.xP = xP;
    this.yP = yP;
    this.xQ = xQ;
    this.yQ = yQ;
    this.zP = zP;
    this.zQ = zQ;

    x = xP;
    y = yP;
    d = 0;

    yInc = 1;
    xInc = 1;
    dx = xQ - xP;
    dy = yQ - yP;

    if (dx < 0) {
      xInc = -1;
      dx = -dx;
    }
    if (dy < 0) {
      yInc = -1;
      dy = -dy;
    }

    if (dy <= dx) {
      m = dy << 1;
      c = dx << 1;

      if (xInc < 0) {
        dx++;
      }
    } else {
      c = dy << 1;
      m = dx << 1;

      if (yInc < 0) {
        dy++;
      }
    }
  }

  // Step makes a single step along the line
  bool step() {
    if (dy <= dx) {
      // Each step X changes
      if (x == xQ) {
        return false;
      }

      x += xInc;
      d += m;
      if (d >= dx) {
        y += yInc;
        d -= c;
      }
    } else {
      // Each step Y changes
      if (y == yQ) {
        return false;
      }

      y += yInc;
      d += m;
      if (d >= dy) {
        x += xInc;
        d -= c;
      }
    }

    return true;
  }
}
