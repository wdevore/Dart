import 'package:vector_math/vector_math.dart';

abstract class Point3<T extends num> {
  late T x;
  late T y;
  late T z;

  Point3();

  Point3.zero();

  void set(T x, T y, T z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

class Point3i extends Point3<int> {
  Point3i.zero() {
    x = 0;
    y = 0;
    z = 0;
  }
}

class Point3d extends Point3<double> {
  Point3d();

  Point3d.zero() {
    x = 0.0;
    y = 0.0;
    z = 0.0;
  }

  Point3d sub(Point3d a, Point3d b) {
    Point3d p = Point3d();
    p.set(a.x - b.x, a.y - b.y, a.z - b.z);
    return p;
  }

  static Vector3 subGenVec(Point3d a, Point3d b) {
    Vector3 v = Vector3.zero();
    v.setValues(a.x - b.x, a.y - b.y, a.z - b.z);
    return v;
  }

  Vector3 asVector3() {
    Vector3 v = Vector3.zero();
    v.setValues(x, y, z);
    return v;
  }
}
