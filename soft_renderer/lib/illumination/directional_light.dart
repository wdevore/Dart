import 'package:soft_renderer/geometry/point3.dart';
import 'package:soft_renderer/illumination/light_base.dart';
import 'package:vector_math/vector_math.dart';

class DirectionalLight extends LightBase {
  @override
  Vector3? calcLightRayWithPoint(Point3d p) {
    return null;
  }

  @override
  Vector3? calcLightRay() {
    return direction;
  }
}
