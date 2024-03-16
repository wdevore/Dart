import 'package:soft_renderer/geometry/point3.dart';
import 'package:vector_math/vector_math.dart';

/// There are two kinds of lights that I support:
/// 1) Point light source. Some call it an Omni-directional light.
/// 2) Directional.
///
/// I think of a Point light source as a source that cast
/// light rays in all directions and is typically not
/// that far from its targets.
///
/// A direction light source would be something that is
/// extremely far away and thus creates light rays that
/// are coming from a fixed direction. A directional light
/// only requires one thing and that is a "direction".
/// Note: This direction describes where the light is coming.
/// For example, a direction of 0,0,-1 means that light is
/// coming from -Z axis and heading towards the +z axis so
/// faces would be brighter when they are facing the -z axis
/// and darkest when facing the +z axis.
///
/// A point light requires a location( of the light) and a
/// target(where the light is shining onto). This allows a
/// lightRay to be astablished for a particular point in space. The
/// target chosen is always the center of the triangle.

abstract class LightBase {
  double ip = 1.0;

  Vector3 base = Vector3.zero();
  Vector3 direction = Vector3.zero();

  int r = 0, g = 0, b = 0;

  void setDirection(
      double bx, double by, double bz, double tx, double ty, double tz) {
    base.setValues(bx, by, bz);
    direction.setValues(tx, ty, tz);
    direction.sub(base); // target - base
    direction.normalize();
  }

  void setDirectionByBase(double bx, double by, double bz) {
    direction.setValues(bx, by, bz);
    direction.normalize();
  }

  void setColor(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  Vector3? calcLightRayWithPoint(Vector3 v);
  Vector3? calcLightRay();
}
