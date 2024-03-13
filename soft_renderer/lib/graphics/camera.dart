import 'package:soft_renderer/geometry/axis_angle.dart';
import 'package:vector_math/vector_math.dart';

class Camera {
  Vector3 tv1 = Vector3.zero(); // temporary bucket vector

  // Position represented as a matrix
  Matrix4 translation = Matrix4.identity();

  // Position represented as a vector
  Vector3 position = Vector3.zero();

  // Orientation is expressed as a series of rotations
  Matrix4 rotation = Matrix4.identity();
  // Rotation represented as an axis angle combination.
  AxisAngle aa = AxisAngle();
  // The inverse rotation
  AxisAngle aaI = AxisAngle();

  // The combined rotation and translation.
  Matrix4 affineTransform = Matrix4.identity();

  void setPosition(double x, double y, double z) {
    // You could think of the following transformation in two ways:
    // 1) push object away from camera or
    // 2) move camera away from objects
    //
    // This routine always assumes that the user is thinking about where to
    // place the camera in the world. The engine is coded to think that the
    // camera is always located at the origin looking down the -Z axis and Y
    // is up (OpenGL) which means that it is the world thats is translating around
    // the camera.
    //
    // Example. If I want to move the camera to the left(-X axis) then
    // effectively I want the world to move to the right (+X axis).
    //
    // Store in world-space perspective.
    position.setValues(x, y, z);
  }

  // We take the inverse of the position because it is stored in
  // world-space and not local-space.
  Vector3 getWorldPosition() {
    tv1.setFrom(position);
    tv1.negate();
    return tv1;
  }

  // We take the inverse of the orientation because it is stored in
  // world-space and not local-space.
  AxisAngle getWorldOrientation() {
    aaI.angle = aa.angle;
    aaI.axis.setFrom(aa.axis);
    aaI.angle *= -1.0;
    return aaI;
  }

  // Angle in Degrees.
  void setOrientation(double angle, double x, double y, double z) {
    // The same concept applies to rotation as it does to translation. You
    // could think of the following transformation in two ways: 1) rotate
    // world into front of camera or 2) rotate camera to look at
    // objects
    //
    // Example: Lets say the camera is sitting at the origin pointed down
    // the -Z axis. We want to tilt the camera to look down, meaning we look
    // at the -Y half of world space, say 25 degrees. This means we want to
    // apply a rotation about the X axis. The question is do we apply a
    // positive rotation or negative rotation? Here is the key, we want to
    // think of NOT the camera being rotated but the world rotating around
    // the camera. And remember in a right-handed system the +X axis is
    // pointing to your right.
    //
    // With that in mind if I want the camera to look down I need to rotate
    // the world around the +X-axis a +25 degrees. This in effect is a -25
    // degree rotation for the camera; if we were actually rotating the camera,
    // which we are not.
    //
    // So the answer is "a positive" rotation about the X axis.
    //
    // Note: I always deal with a right-handed coordinate system, hence CCW
    // rotations are around axies that always point at YOU (your thumb), not
    // away from you. The angle given is in degrees.
    //
    // Store orienation is world-space perspective.
    aa.axis.setValues(x, y, z);
    aa.angle = angle * degrees2Radians;
  }

  Matrix4 getTransformMatrix4() {
    // We want a camera that pans and not orbits which means we
    // need to control the order of the multiplication which means
    // we need two matrices; one for rotation and the other for
    // translation.
    AxisAngle aa = getWorldOrientation();

    Quaternion quat = Quaternion.axisAngle(aa.axis, aa.angle);

    rotation.setRotation(quat.asRotationMatrix());
    translation.setTranslation(getWorldPosition());

    // Note the order in which I perform the multiplication. I do a
    // rotation followed by a translation which will create a panning effect.
    //
    // To have an orbiting effect I would do a translation first followed by
    // a rotation.
    affineTransform = rotation * translation; // Pan
    // affineTransform = translation * rotation; // Orbit

    return affineTransform;

    // By calling the setRotation and setTranslation methods on
    // the SAME matrix, regardless of whether you call setRotation
    // first or second, this will create a matrix that represents
    // a translation first followed by a rotation which is in effect
    // an orbiting camera.
    //
    // This is shown below.
    //    affineTransform.setRotation(aa);
    //    affineTransform.setTranslation(position);
    //    return affineTransform;
    //
    // I personally like to control the order so I use two matrices.
  }
}
