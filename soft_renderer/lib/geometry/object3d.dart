import 'package:soft_renderer/geometry/axis_angle.dart';
import 'package:soft_renderer/palette/colors.dart' as palette;
import 'package:vector_math/vector_math.dart';

class Object3D {
  String name = '';

  // The color of the entire object
  int color = 0;

  // Position represented as a matrix
  final Matrix4 _translation = Matrix4.identity();

  // Position
  final Vector3 position = Vector3.zero();
  // Position represented as a vector4 homogenous coord for transforms
  final Vector4 pos4 = Vector4.zero();

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

  // Conversions
  final Quaternion quat = Quaternion.identity();

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
    quat.setAxisAngle(aa.axis, aa.angle);

    // Then into Matrix
    _rotation.setIdentity();
    _rotation.setRotation(quat.asRotationMatrix());

    _translation.setIdentity();
    _translation.setTranslation(position);

    // Note: the order in which I perform the multiplication. To do a
    // rotation followed by a translation will cause an orbiting effect.
    //
    // To have a rotating effect about the objects local position
    // I would do a translation first followed by a rotation. As done below.
    // By multiplying Rotation and Translation methods on
    // the SAME matrix, this will create a matrix that represents
    // a translation first followed by a rotation which is in effect
    // an orbiting camera.
    //
    // I personally like to control the order so I use two matrices.
    _affineTransform.setIdentity();
    // _affineTransform.setFrom(_translation * _rotation);
    _affineTransform.multiply(_translation);
    _affineTransform.multiply(_rotation);

    return _affineTransform;
  }

  void setOrientation(double angle, double x, double y, double z) {
    aa.axis.setValues(x, y, z);
    aa.angle = angle * degrees2Radians;
  }

  int mapColor(int r, int g, int b) {
    return (255 << 24) | (r << 16) | (g << 8) | (b);
  }
}
