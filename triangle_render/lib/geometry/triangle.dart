// Triangle is a single triangle without shared edges.
// It can decompose into two triangles: flat-top and flat-bottom
// Each decompose triangle is made of Edges.
import 'package:triangle_render/palette/colors.dart';
import 'package:triangle_render/raster/raster_buffer.dart';

import 'edge.dart';

class Triangle {
  // Indices into the vertex transformation buffer.
  int x1 = 0, y1 = 0, x2 = 0, y2 = 0, x3 = 0, y3 = 0;
  double z1 = 0.0, z2 = 0.0, z3 = 0.0;

  int posX = 0;
  int posY = 0;

  // Edges used for rasterization.
  Edge? leftEdge, rightEdge;

  Triangle() {
    leftEdge = Edge();
    rightEdge = Edge();
  }

  // Set the vertices of the triangle
  void set(int x1, int y1, int x2, int y2, int x3, int y3) {
    this.x1 = posX + x1;
    this.y1 = posY + y1;
    this.x2 = posX + x2;
    this.y2 = posY + y2;
    this.x3 = posX + x3;
    this.y3 = posY + y3;
  }

  // Draw renders an outline
  void draw(RasterBuffer raster) {
    raster.pixelColor = Colors().white;

    sort();

    if (y2 == y3) {
      // Case for flat-bottom triangle
      raster.drawLineAmmeraal(x1, y1, x2, y2); // Diagonal/Right
      raster.drawLineAmmeraal(x2, y2, x3, y3); // Bottom
      raster.drawLineAmmeraal(x1, y1, x3, y3); // Left
    } else if (y1 == y2) {
      // Case for flat-top triangle
      raster.drawLineAmmeraal(x1, y1, x3, y3); // Diagonal/Right
      raster.drawLineAmmeraal(x1, y1, x2, y2); // Top
      raster.drawLineAmmeraal(x2, y2, x3, y3); // Left
    } else {
      // General case
      // split the triangle into two triangles: top-half and bottom-half
      var x = (x1.toDouble() +
              ((y2 - y1).toDouble() / (y3 - y1).toDouble()) *
                  (x3 - x1).toDouble())
          .toInt();

      // Top triangle
      // flat-bottom
      raster.drawLineAmmeraal(x1, y1, x2, y2); // Right
      raster.drawLineAmmeraal(x2, y2, x, y2); // Bottom
      raster.drawLineAmmeraal(x1, y1, x, y2); // Left

      // Bottom triangle
      // flat-top
      raster.drawLineAmmeraal(x2, y2, x3, y3); // Left
      raster.drawLineAmmeraal(x2, y2, x, y2); // Top
      raster.drawLineAmmeraal(x, y2, x3, y3); // Right
    }
  }

// Fill renders as filled
  void fill(RasterBuffer raster) {
    sort();

    raster.pixelColor = Colors().white;

    // Draw horizontal lines between left/right edges.

    if (y2 == y3) {
      // Case for flat-bottom triangle
      leftEdge?.set(x1, y1, x3, y3, z1, z3);
      rightEdge?.set(x1, y1, x2, y2, z1, z2);
      raster.fillTriangleAmmeraal(leftEdge!, rightEdge!, true, false);
      // raster.DrawLine(x2, y2, x3, y3, 1.0, 1.0) // Bottom <-- overdraw
    } else if (y1 == y2) {
      // Case for flat-top triangle
      leftEdge?.set(x1, y1, x3, y3, z1, z3);
      rightEdge?.set(x2, y2, x3, y3, z2, z3);
      raster.fillTriangleAmmeraal(leftEdge!, rightEdge!, false, false);
      // raster.DrawLine(x1, y1, x2, y2, 1.0, 1.0) // Top <-- overdraw
    } else {
      // General case:
      // Split the triangle into two triangles: top-half and bottom-half
      var x = ((x1).toDouble() +
              ((y2 - y1).toDouble() / (y3 - y1).toDouble()) *
                  (x3 - x1).toDouble())
          .toInt(); // x intercept

      // --------------------------
      // Top triangle flat-bottom
      // y2 will always be in the "middle" which means it is always at the bottom of the flat-bottom
      // Set the edges for scanning left to right
      leftEdge?.set(x1, y1, x, y2, 1.0, 1.0);
      rightEdge?.set(x1, y1, x2, y2, 1.0, 1.0);

      raster.fillTriangleAmmeraal(leftEdge!, rightEdge!, true, false);

      // --------------------------
      // Bottom triangle flat-top
      leftEdge?.set(x, y2, x3, y3, 2.0, 2.0);
      rightEdge?.set(x2, y2, x3, y3, 2.0, 2.0);

      // raster.pixelColor = Colors().white;
      raster.fillTriangleAmmeraal(leftEdge!, rightEdge!, false, false);
    }
  }

  void sort() {
    var x = 0;
    var y = 0;

    // Make y1 <= y2 if needed
    if (y1 > y2) {
      x = x1;
      y = y1;
      x1 = x2;
      y1 = y2;
      x2 = x;
      y2 = y;
    }

    // Now y1 <= y2. Make y1 <= y3
    if (y1 > y3) {
      x = x1;
      y = y1;
      x1 = x3;
      y1 = y3;
      x3 = x;
      y3 = y;
    }

    // Now y1 <= y2 and y1 <= y3. Make y2 <= y3
    if (y2 > y3) {
      x = x2;
      y = y2;
      x2 = x3;
      y2 = y3;
      x3 = x;
      y3 = y;
    }
  }
}
