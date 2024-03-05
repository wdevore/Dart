// Triangle is a single triangle without shared edges.
// It can decompose into two triangles: flat-top and flat-bottom
// Each decompose triangle is made of Edges.
import 'package:dart_sdl2/geometry/edge.dart';

class Triangle {
  // Indices into the vertex transformation buffer.
  int x1 = 0, y1 = 0, x2 = 0, y2 = 0, x3 = 0, y3 = 0;
  double z1 = 0.0, z2 = 0.0, z3 = 0.0;

  // Edges used for rasterization.
  Edge? leftEdge, rightEdge;

  Triangle() {
    leftEdge = Edge();
    rightEdge = Edge();
  }

  // Set the vertices of the triangle
  void set(int x1, y1, x2, y2, x3, y3) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.x3 = x3;
    this.y3 = y3;
  }

  // Draw renders an outline
  // void draw(RasterBuffer raster) {
  //   sort();

  //   if (y2 == y3) {
  //     // Case for flat-bottom triangle
  //     raster.DrawLineAmmeraal(x1, y1, x2, y2); // Diagonal/Right
  //     raster.DrawLineAmmeraal(x2, y2, x3, y3); // Bottom
  //     raster.DrawLineAmmeraal(x1, y1, x3, y3); // Left
  //   } else if (y1 == y2) {
  //     // Case for flat-top triangle
  //     raster.DrawLineAmmeraal(x1, y1, x3, y3); // Diagonal/Right
  //     raster.DrawLineAmmeraal(x1, y1, x2, y2); // Top
  //     raster.DrawLineAmmeraal(x2, y2, x3, y3); // Left
  //   } else {
  //     // General case
  //     // split the triangle into two triangles: top-half and bottom-half
  //     var x = (x1.toDouble() +
  //             ((y2 - y1).toDouble() / (y3 - y1).toDouble()) *
  //                 (x3 - x1).toDouble())
  //         .toInt();

  //     // Top triangle
  //     // flat-bottom
  //     raster.DrawLineAmmeraal(x1, y1, x2, y2); // Right
  //     raster.DrawLineAmmeraal(x2, y2, x, y2); // Bottom
  //     raster.DrawLineAmmeraal(x1, y1, x, y2); // Left

  //     // Bottom triangle
  //     // flat-top
  //     raster.DrawLineAmmeraal(x2, y2, x3, y3); // Left
  //     raster.DrawLineAmmeraal(x2, y2, x, y2); // Top
  //     raster.DrawLineAmmeraal(x, y2, x3, y3); // Right
  //   }
  // }

// Fill renders as filled
// void fill(RasterBuffer raster ) {
// 	sort();

// 	// Draw horizontal lines between left/right edges.

// 	if (y2 == y3) {
// 		// Case for flat-bottom triangle
// 		leftEdge?.set(x1, y1, x3, y3, z1, z3);
// 		rightEdge?.set(x1, y1, x2, y2, z1, z2);
// 		raster.fillTriangleAmmeraal(leftEdge, rightEdge, true, false);
// 		// raster.DrawLine(x2, y2, x3, y3, 1.0, 1.0) // Bottom <-- overdraw
// 	} else if (y1 == y2) {
// 		// Case for flat-top triangle
// 		leftEdge?.set(x1, y1, x3, y3, z1, z3);
// 		rightEdge?.set(x2, y2, x3, y3, z2, z3);
// 		raster.fillTriangleAmmeraal(leftEdge, rightEdge, false, false);
// 		// raster.DrawLine(x1, y1, x2, y2, 1.0, 1.0) // Top <-- overdraw
// 	} else {
// 		// General case:
// 		// Split the triangle into two triangles: top-half and bottom-half
// 		var x = ((x1).toDouble() + ((y2-y1).toDouble()/(y3-y1).toDouble())*(x3-x1).toDouble()).toInt(); // x intercept

// 		// --------------------------
// 		// Top triangle flat-bottom
// 		// y2 will always be in the "middle" which means it is always at the bottom of the flat-bottom
// 		// Set the edges for scanning left to right
// 		leftEdge?.set(x1, y1, x, y2, 1.0, 1.0);
// 		rightEdge?.set(x1, y1, x2, y2, 1.0, 1.0);

// 		raster.setPixelColor(color.RGBA{R: 255, G: 255, B: 255, A: 255});
// 		raster.fillTriangleAmmeraal(leftEdge, rightEdge, true, false);

// 		// --------------------------
// 		// Bottom triangle flat-top
// 		leftEdge?.set(x, y2, x3, y3, 2.0, 2.0);
// 		rightEdge?.set(x2, y2, x3, y3, 2.0, 2.0);

// 		raster.setPixelColor(color.RGBA{R: 255, G: 255, B: 255, A: 255});
// 		raster.fillTriangleAmmeraal(leftEdge, rightEdge, false, false);
// 	}
// }

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
