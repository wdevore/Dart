import 'package:soft_renderer/illumination/light_base.dart';
import 'package:vector_math/vector_math.dart';

class DirectionalLight extends LightBase {
  @override
  Vector3? calcLightRayWithPoint(Vector3 p) {
    return null;
  }

  @override
  Vector3? calcLightRay() {
    return direction;
  }
}
