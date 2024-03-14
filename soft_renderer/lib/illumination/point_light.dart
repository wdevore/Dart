import 'package:soft_renderer/geometry/point3.dart';
import 'package:soft_renderer/illumination/light_base.dart';
import 'package:vector_math/vector_math.dart';

class PointLight extends LightBase {
  /// [p] = point on triangle
  /// ---
  /// Form a ray from a point(p) on the triangle to light source:
  ///
  /// light position - triangle center.
  @override
  Vector3? calcLightRayWithPoint(Point3d p) {
    direction.setFrom(base);
    direction.sub(p.asVector3()); // base - p
    direction.normalize();
    return direction;
  }

  @override
  Vector3? calcLightRay() {
    return null;
  }
}
