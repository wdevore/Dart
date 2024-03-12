import 'dart:math';

import 'package:soft_renderer/geometry/axis_angle.dart';
import 'package:soft_renderer/geometry/point3.dart';
import 'package:vector_math/vector_math.dart';

class ArcBall {
  static const int noAxes = 0;
  static const int lgNSEGS = 4;
  static const int nSEGS = 1 << lgNSEGS;
  static const double ePSILON = .0001;

  double radius = 0.0;
  Quaternion qNow = Quaternion.identity();
  Quaternion qDown = Quaternion.identity();
  Quaternion qDrag = Quaternion.identity();
  Vector3 vNow = Vector3.zero();
  Vector3 vDown = Vector3.zero();
  Vector3 vFrom = Vector3.zero();
  Vector3 vTo = Vector3.zero();
  Vector3 vrFrom = Vector3.zero();
  Vector3 vrTo = Vector3.zero();
  Matrix4 mNow = Matrix4.identity();
  Matrix4 mDown = Matrix4.identity();

  bool bDragging = false;

  Vector3 ballMouse = Vector3.zero();
  Quaternion q = Quaternion.identity();
  Quaternion qConj = Quaternion.identity();
  List<Vector3> pts = List<Vector3>.filled(nSEGS + 1, Vector3.zero());
  Vector3 vVector = Vector3.zero();
  Vector3 base = Vector3.zero();
  Vector3 direction = Vector3.zero();
  Point3 canvasSize = Point3();
  Vector3 canvasCenter = Vector3.zero();
  late AxisAngle aaYaxis;
  AxisAngle aa = AxisAngle();
  Vector3 los = Vector3.zero();
  Vector3 up = Vector3.zero();
  Vector3 horz = Vector3.zero();

  // Position represented as a matrix
  Matrix4 translation = Matrix4.identity();

  // Orientation is expressed as a series of rotations
  Matrix4 rotation = Matrix4.identity();

  // The combined rotation and translation.
  Matrix4 affineTransform = Matrix4.identity();

  // Point3 p1 = Point3();
  // Point3 p2 = Point3();
  Vector3 v1 = Vector3.zero();
  Vector3 v2 = Vector3.zero();

  // Ken's arcball must be based on 2D screen coords where the +y is upwards respectively.
  // However, SWT 2D screen coords are such that +y is downward.
  // In order to sync with Ken's arcball I flip the screen coords to match Ken's
  // y = (Height - y).
  // Also, a conjugate is needed as well as a (-y).

  bool screenYOrientation = true; // default to GL, Y is upwards.

  ArcBall() {
    aaYaxis = AxisAngle();
    aaYaxis.axis.setValues(0.0, 1.0, 0.0);
    aaYaxis.angle = 180.0 * degrees2Radians;

    canvasCenter.setValues(0.0, 0.0, 0.0);
    radius = 0.0;
    vDown.setValues(0.0, 0.0, 0.0);
    vNow.setValues(0.0, 0.0, 0.0);
    qDown.setValues(0.0, 0.0, 0.0, 1.0);
    qNow.setValues(0.0, 0.0, 0.0, 1.0);

    base.setValues(0.0, 0.0, 0.0); // GL default base location. world origin.

    affineTransform.setIdentity();
    rotation.setIdentity();
    translation.setIdentity();
  }

  // Set the center and size of the controller.
  void place(Vector3 v, double r) {
    canvasCenter.setFrom(v);
    radius = r;
  }

  void resize(int width, int height) {
    canvasSize.x = width;
    canvasSize.y = height;
    canvasCenter.x = canvasSize.x / 2.0;
    canvasCenter.y = canvasSize.y / 2.0;
    // 2.5 gives a decent size ball. 2.0 would give little room on the sides.
    radius = min(canvasSize.x, canvasSize.y) / 2.5;
  }

  void remapScreenCoords(Point3 p) {
    if (!screenYOrientation) {
      vNow.setValues(p.x.toDouble(), (canvasSize.y - p.y).toDouble(), 0.0);
    } else {
      vNow.setValues(p.x.toDouble(), (canvasSize.y - p.y).toDouble(), 0.0);
    }
  }

  // Incorporate new mouse position.
  void mouse(Point3 p) {
    remapScreenCoords(p);
  }

  // Using vDown, vNow, dragging, and compute rotation etc.
  void update() {
    vTo.setFrom(mouseOnSphere(vNow));

    if (bDragging) {
      qDrag = mapFromBallPoints(vFrom, vTo);
      qNow = qDrag * qDown;
    }

    mapToBallPoints(qDown, vrFrom, vrTo);
    q.setFrom(qNow);
  }

  // Construct a unit quaternion from two points on unit sphere.
  Quaternion mapFromBallPoints(Vector3 from, Vector3 to) {
    vVector.crossInto(from, to);
    q.setAxisAngle(vVector, from.dot(to));
    return q.clone();
  }

  Vector3 mouseOnSphere(Vector3 mouse) {
    ballMouse.x = (mouse.x - canvasCenter.x) / radius;
    ballMouse.y = (mouse.y - canvasCenter.y) / radius;
    ballMouse.z = 0.0;
    double mag = ballMouse.length2;
    if (mag > 1.0) {
      double scale = 1.0 / sqrt(mag);
      ballMouse.scale(scale);
    } else {
      ballMouse.z = sqrt(1.0 - mag);
    }
    return ballMouse;
  }

  void mapToBallPoints(Quaternion q, Vector3 arcFrom, Vector3 arcTo) {
    double s = sqrt(q.x * q.x + q.y * q.y);
    if (s == 0.0) {
      arcFrom.setValues(0.0, 1.0, 0.0);
    } else {
      arcFrom.setValues(-q.y / s, q.x / s, 0.0);
    }
    arcTo.x = q.w * arcFrom.x - q.z * arcFrom.y;
    arcTo.y = q.w * arcFrom.y + q.z * arcFrom.x;
    arcTo.z = q.x * arcFrom.y - q.y * arcFrom.x;
    if (q.w < 0.0) arcFrom.setValues(-arcFrom.x, -arcFrom.y, 0.0);
  }

  // 'dir` is the direction to rotate to.
  void lookInDirection(Vector3 dir) {
    // vVector is the default GL camera direction = -Z axis
    // vNow is the axis of rotation = cross product of vDir into (-Z axis)
    //
    // Remember the cross product is not cummunative so (-Z axis) into vDir
    // produces the opposite result, not good. We are using Ken's system so
    // I try to be consistent hence I use the same system that GL uses and
    // that is a right-handed system. Your fingers curl in the direction of
    // the cross product and your thumb is the resultant normal vector.
    // The dot product is communative so its order dose not matter.
    //
    // Hence, qNow = [(vDir.cross(-Z axis)), 1.0 + (-Z axis).dot(vDir)]
    direction.setFrom(dir); // remember the direction for later use.
    direction.normalize(); // make sure it is of unit length.
    vVector.setValues(0.0, 0.0, -1.0); // GL default camera direction
    vNow.crossInto(direction, vVector); // get the axis of rotation
    double dot = vVector.dot(direction); // and how much we will rotate by.
    // Check to see if given direction is pointing is the exact opposite of the camera direction.
    // In GL the camera is always sitting at the world origin looking down the -Z axis.
    //
    // The dot product tells the angle between the direction and camera and is in the range of
    // -1 to 0 to 1. 0 meaning they are perpindicular, -1 meaning they are pointing in opposite
    // directions.
    //
    // We are only concerned with a -1 dot product or at least within an Epsilon of it.
    // We will get a -1 when the direction is on or close to the +Z axis. The dot product of
    // -Z and +Z gives -1.
    //
    // The arcball fails if the desired viewing direction and camera direction are pointing in opposite
    // directions. Why? Because there is an infinite numbers of rotations that would satifiy the
    // request. The resultent quaternion would be undefined. So instead, a manual rotation is
    // performed about the +y axis as shown below.
    double delta = 1.0 - (dot).abs();
    if (delta < ePSILON && dot < 0.0) {
      // Close enough
      qNow.setAxisAngle(aaYaxis.axis, aaYaxis.angle);
    } else {
      // double angle = (double)Math.toDegrees(dot);
      // double s = (double)Math.sin(angle/2.0);
      // double w = (double)Math.cos(angle/2.0);

      // qNow.set(s*vNow.x, s*vNow.y, s*vNow.z, w);

      qNow.setValues(vNow.x, vNow.y, vNow.z, -(1.0 + dot));

      // aa.set(vNow.x, vNow.y, vNow.z, -(double)Math.acos(dot));
      // qNow.set(aa);
    }

    qNow.normalize();

    qDown.setFrom(qNow);
  }

  void lookAt(Vector3 target) {
    // 'base' is typically the camera's base location. In trivial examples
    // the base is located at the world origin so the target is pretty much
    // the direction normalized.
    direction.setFrom(target);
    direction.sub(base);

    lookInDirection(direction);
  }

  void lookFromBase(Vector3 base, Vector3 target) {
    // If the camera is located somewhere other than the world origin then
    // the direction is = (target - base) normalized.
    this.base.setFrom(base);

    lookAt(target);
  }

  void lookAtComponents(
      double xb, double yb, double zb, double xt, double yt, double zt) {
    base.setValues(xb, yb, zb);
    direction.setValues(xt, yt, zt);
    direction.sub(base);
    lookInDirection(direction);
  }

  void computeLOS() {
    qConj.setFrom(qNow);
    qConj.conjugate();
    q.setValues(0.0, 0.0, -1.0, 0.0); // -Z

    q = q * qConj * q * qNow;
    // q.mul(qConj, q);
    // q.mul(qNow);

    los.setValues(q.x, q.y, q.z); // the camera's los
    los.normalize();
  }

  // Get the transform from world-space to view-space. This means returning the
  // opposite transform of the arcball.
  Matrix4 calcTransformMatrix4() {
    // We want a camera that pans and not orbits which means we
    // need to control the order of the multiplication which means
    // we need two matrices; one for rotation and the other for
    // translation.
    // If the screen coordinates where reverse we would use the conjugate.
    //qConj.conjugate(qNow);
    rotation.setIdentity();
    rotation.setRotation(qNow.asRotationMatrix());

    translation.setIdentity();
    vVector.setFrom(base);
    vVector.negate();
    translation.setTranslation(vVector);

    /*
		 * Note the order in which I perform the multiplication. I do a
		 * rotation followed by a translation which will create a panning effect.
		 * 
		 * To have an orbiting effect I would do a translation first followed by
		 * a rotation. Note: post multiply requires TxR not RxT.
		 */
    affineTransform.setIdentity();
    affineTransform = translation * rotation;

    return affineTransform;
  }

  Vector3 getWorldPosition() {
    v1.setFrom(base);
    calcTransformMatrix4();
    affineTransform.invert();
    v2 = affineTransform.transform3(v1);
    return v2;
  }
}
