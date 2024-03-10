/*
  Mar 9, 2024
  William Cleveland
*/

import 'package:vector_math/vector_math.dart';

class Triangle {
  //A triangle consists of 3 vertices (CCW order)
  int i1, i2, i3; // vertex indices

  // Edge visibility
  final List<int> edges = List.filled(3, 0); // edge indices

  final Vector3 center = Vector3.zero();
  final Vector3 normal = Vector3.zero();

  // Temporary storage vectors
  final Vector3 tv1 = Vector3.zero();
  final Vector3 tv2 = Vector3.zero();
  final Vector3 tv3 = Vector3.zero();

  Triangle(this.i1, this.i2, this.i3);

  void setEdgeIndex(int edge, int index) {
    edges[edge - 1] = index - 1;
  }

  int getEdgeIndex(int edge) {
    return edges[edge - 1];
  }

  @override
  String toString() => 'V: {$i1, $i2, $i3}, C: $center, N: $normal';

  Vector3 calcNormal(Vector3 p1, Vector3 p2, Vector3 p3) {
    // p2 - p1
    tv1.setFrom(p2);
    tv1.sub(p1);

    // p3 - p1
    tv2.setFrom(p3);
    tv2.sub(p1);

    // normal vector non-normalized (tv1 into tv2)
    tv1.crossInto(tv2, normal);

    return normal;
  }

  void setCenter(Vector3 p1, Vector3 p2, Vector3 p3) {
    // get center of triangle
    tv1.setValues(p1.x + p2.x, p1.y + p2.y, p1.z + p2.z);
    tv1.scale(1.0 / 2.0);

    tv2.setValues(p1.x + p3.x, p1.y + p3.y, p1.z + p3.z);
    tv2.scale(1.0 / 2.0);

    center.setValues(tv1.x + tv2.x, tv1.y + tv2.y, tv1.z + tv2.z);
    center.scale(1.0 / 2.0);
  }
}
