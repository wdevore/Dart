import 'package:soft_renderer/geometry/axis_angle.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  test('Transform', () {
    Matrix4 _translation = Matrix4.identity();
    Vector3 position = Vector3.zero();
    Matrix4 _rotation = Matrix4.identity();
    Matrix4 _affineTransform = Matrix4.identity();
    AxisAngle aa = AxisAngle();
    aa.axis = Vector3.zero();
    aa.axis.x = 0.0;
    aa.axis.y = 0.0;
    aa.axis.z = 1.0;
    aa.angle = 45.0 * degrees2Radians;

    // Note: this URL explains it:
    // https://www.brainvoyager.com/bv/doc/UsersGuide/CoordsAndTransforms/SpatialTransformationMatrices.html#:~:text=3D%20Affine%20Transformation%20Matrices,point%20(or%20vector)%20y.
    // We must use Vector4's because vecmath assumes Matrix4 uses
    // homogeneous coordinates. It would have been more intuitive
    // if Vector3 was actually thought of as vectors and not points.
    Vector4 pos4 = Vector4.zero();

    position.x = 10.0;
    position.y = 0.0;
    position.z = 0.0;

    pos4.x = position.x;
    pos4.y = position.y;
    pos4.z = position.z;
    // W = 0 means position is a vector, W = 1 means a point representation.
    pos4.w = 0.0;

    Quaternion q = Quaternion.axisAngle(aa.axis, aa.angle);

    // Then into Matrix
    _rotation.setIdentity();
    _rotation.setRotation(q.asRotationMatrix());
    print('_rotation:\n $_rotation');

    _translation.setIdentity();
    _translation.setTranslation(position);
    print('_translation:\n $_translation');

    _affineTransform.setIdentity();
    _affineTransform = _translation * _rotation;
    print('_affineTransform:\n $_affineTransform');

    Vector4 vec4 = _affineTransform.transform(pos4);
    position.setValues(vec4.x, vec4.y, vec4.z);
    print('position:\n $position');
  });
}
