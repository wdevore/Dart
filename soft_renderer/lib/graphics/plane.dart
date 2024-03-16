import 'dart:ffi';

import 'package:soft_renderer/model/constants.dart';
import 'package:vector_math/vector_math.dart';

enum PlaneResult {
  coplanar,
  front,
  back, // back side
  intersected,
  clipped,
}

class Plane {
  Vector3 normal = Vector3.zero();
  Vector3 transformedNormal = Vector3.zero();

  Vector3 point = Vector3.zero();
  Vector3 transformedPoint = Vector3.zero();

  Vector3 intersection = Vector3.zero();

  Vector3 u = Vector3.zero();
  Vector3 w = Vector3.zero();

  void setNormal(double x, double y, double z) {
    normal.setValues(x, y, z);
    normal.normalize();
    transformedNormal.setFrom(normal);
  }

  void setPoint(double x, double y, double z) {
    point.setValues(x, y, z);
    transformedPoint.setValues(point.x, point.y, point.z);
  }

  void setPointVector(Vector3 v) {
    point.setFrom(v);
    transformedPoint.setFrom(v);
  }

  /// Determine if point is in front of plane or on the back side.
  PlaneResult whereIsPoint(Vector3 p) {
    w.setValues(p.x, p.y, p.z);
    w.sub(transformedPoint);
    double d = transformedNormal.dot(w);

    if (d.abs() < Constants.ePSILON) {
      // it is coplanar
      return PlaneResult.coplanar;
    }

    if (d < 0.0) return PlaneResult.back;

    return PlaneResult.front; // frontside
  }

  /// Find intersection of given line with this plane.
  ///
  /// [vP] is start of line, [vQ] is end of line.
  PlaneResult intersect(Vector3 vP, Vector3 vQ) {
    u = vQ - vP;
    w = vP - transformedPoint;

    double d = transformedNormal.dot(u);
    double n = -transformedNormal.dot(w);

    if (d.abs() < Constants.ePSILON) {
      if (n == 0.0) {
        return PlaneResult.coplanar;
      } else {
        return PlaneResult.back; // default to backside.
      }
    }

    // They are not parallel. compute intersection
    double sI = n / d;
    if (sI < 0.0 || sI > 1.0) {
      if (sI < 0.0) {
        return PlaneResult.back;
      } else {
        return PlaneResult.front;
      }
    }

    // intersection = vP + sI*u
    u.scale(sI);
    intersection = vP + u;

    return PlaneResult.intersected;
  }

  /// Clip line with this plane's front.
  ///
  /// [vP] is start of line, [vQ] is end of line.
  ///
  /// [clP] and [clQ] is clipped line.
  /// - PlaneResult.back = line was completely on the backside
  /// - PlaneResult.coplanar = one or both points were coplanar however it
  ///   is still considered on the backside
  /// - PlaneResult.clipped = line was clipped.
  PlaneResult clipToFront(Vector3 vP, Vector3 vQ, Vector3 clP, Vector3 clQ) {
    /*
		 * Clip line to a world plane
		 */
    PlaneResult iP = whereIsPoint(vP);
    PlaneResult iQ = whereIsPoint(vQ);

    if (iP == PlaneResult.coplanar && iQ == PlaneResult.coplanar) {
      return PlaneResult.back; // neither point was on the front side
    }

    // One of the points is coplanar. The other on the backside.
    // So I consider this NOT visible.
    if (iP == PlaneResult.back && iQ == PlaneResult.coplanar) {
      return PlaneResult.coplanar;
    }
    if (iP == PlaneResult.coplanar && iQ == PlaneResult.back) {
      return PlaneResult.coplanar;
    }

    if ((iP == PlaneResult.back && iQ == PlaneResult.clipped) ||
        (iP == PlaneResult.clipped && iQ == PlaneResult.back)) {
      // One point is coplanar and the other is front. No cliping needed
      clP.setFrom(vP);
      clQ.setFrom(vQ); // End Point
    } else {
      PlaneResult l = intersect(vP, vQ);

      switch (l) {
        case PlaneResult.intersected:
          // Line intersects
          clQ.setFrom(intersection); // New clipped End Point
          break;
        default:
          // Line is in front of plane
          clQ.setFrom(vQ);
          break;
      }

      // We want only the point that was on the front of the plane
      if (iP == PlaneResult.clipped || iP == PlaneResult.back) {
        clP.setFrom(vP);
      } else if (iQ == PlaneResult.clipped || iQ == PlaneResult.back) {
        // clP will be the front point.
        clP.setFrom(vQ);
      }
    }

    // Indicate the segment was clipped.
    return PlaneResult.clipped;
  }
}
