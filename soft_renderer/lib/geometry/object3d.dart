import 'package:soft_renderer/geometry/axis_angle.dart';
import 'package:soft_renderer/palette/colors.dart' as palette;
import 'package:vector_math/vector_math.dart';

class Object3D {
  String name = '';

  // The color of the entire object
  int color = 0;

  // Position represented as a matrix
  final Matrix4 _translation = Matrix4.identity();

  // Position represented as a vector
  final Vector3 position = Vector3.zero();

  // Orientation is expressed as a series of rotations
  final Matrix4 _rotation = Matrix4.identity();

  // Rotation represented as an axis angle combination.
  final AxisAngle aa = AxisAngle();

  // The combined rotation and translation.
  final Matrix4 _affineTransform = Matrix4.identity();

  // An object consists of vectices that the triangles index into.
  final List<Vector3> vertices = [];
  final List<Vector3> vertexNormals = [];

  // Pre allocations
  final Vector3 p1 = Vector3.zero();
  final Vector3 p2 = Vector3.zero();
  final Vector3 p3 = Vector3.zero();

  @override
  String toString() => name;

  void reset() {
    _affineTransform.setIdentity();
    _rotation.setIdentity();
    _translation.setIdentity();
    vertices.clear();
    vertexNormals.clear();
    position.setZero();
    color = 0;
  }

  void addVertex(Vector3 v) {
    vertices.add(Vector3.copy(v));
  }

  // The raster buffer is a byte buffer of 32 bit bytes represented
  // as an int.
  void setColor(int r, int g, int b, int a) {
    color = palette.Colors.convertRGBAtoUint8([r, g, b, a]);
  }

  // This method returns a matrix that transforms the object from local to
  // world-space; NOT camera or view-space.

  Matrix4 modelToWorldMatrix() {
    // Convert Axis-Angle into Quaternion
    Quaternion q = Quaternion.axisAngle(aa.axis, aa.angle);

    // Then into Matrix
    _rotation.setIdentity();
    _rotation.setRotation(q.asRotationMatrix());

    _translation.setIdentity();
    _translation.setTranslation(position);

    /*
		 * Note the order in which I perform the multiplication. To do a
		 * rotation followed by a translation will cause an orbiting effect.
		 * 
		 * To have a rotating effect about the objects local position
		 * I would do a translation first followed by a rotation. As done below.
		 */
    _affineTransform.setIdentity();
    _affineTransform.multiply(_translation);
    _affineTransform.multiply(_rotation);

    return _affineTransform;

    /*
		 * By calling the setRotation and setTranslation methods on
		 * the SAME matrix, regardless of whether you call setRotation
		 * first or second, this will create a matrix that represents
		 * a translation first followed by a rotation which is in effect
		 * an orbiting camera.
		 * 
		 * This is shown below.
		 *    affineTransform.setRotation(aa);
		 *    affineTransform.setTranslation(position);
		 *    return affineTransform;
		 * 
		 * I personally like to control the order so I use two matrices.
		 */
  }
}
