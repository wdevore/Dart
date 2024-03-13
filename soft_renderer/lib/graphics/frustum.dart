import 'package:vector_math/vector_math.dart';

class Frustum {
  // Frustum dimensions
  double left = 0.0;
  double right = 0.0;
  double bottom = 0.0;
  double top = 0.0;
  double near = 0.0;
  double far = 0.0;
  double width = 0.0; // These typically are the same as viewport dim=0.0s
  double height = 0.0;
  double depth = 0.0;

  Matrix4 viewVolume = Matrix4.identity();

  // Clipping planes
  Plane nearPlane = Plane();

  void setWidth(double left, double right) {
    this.left = left;
    this.right = right;
    width = (right - left).abs();
  }

  void setHeight(double top, double bottom) {
    this.top = top;
    this.bottom = bottom;
    height = (top - bottom).abs();
  }

  void setDepth(double near, double far) {
    this.near = near;
    this.far = far;
    depth = (this.near - this.far).abs();
  }

  void setNearPlane(double nx, double ny, double nz) {
    nearPlane.normal.setValues(nx, ny, nz);
    nearPlane.constant = 0.0;
  }

  // Based on OpenGL implementation.
  void calcViewVolumeMatrix() {
    /*
		 * 0           1           2           3   <-- Column major number
		 * -------------------------
		 * 0{00}2*n/(r-l) 4{01}          8{02}(r+l)/(r-l)    12(03)
		 * 1{10}          5{11}2*n(t-b)  9{12}(t+b)/(t-b)    13{13}
		 * 2{20}          6{21}          10{22}(f+n)/(n-f)   14{23}2(f*n)/(n-f)
		 * 3{30}          7{31}          11{32}-1            15{33}
		 */
    viewVolume.row0.setValues(
      (2.0 * near) / (right - left),
      0.0,
      (right + left) / (right - left),
      0.0,
    );

    viewVolume.row1.setValues(
      0.0,
      (2.0 * near) / (top - bottom),
      (top + bottom) / (top - bottom),
      0.0,
    );

    viewVolume.row2.setValues(
      0.0,
      0.0,
      (far + near) / (near - far),
      2.0 * (far * near) / (near - far),
    );

    viewVolume.row3.setValues(
      0.0,
      0.0,
      -1.0,
      0.0,
    );
  }

  // <p>
  // The camera is located at 0,0,1 after view-volume matrix is applied.
  // The Near plane is located somewhere greater than 0,0,0 along the -z-axis.
  // For example, if near = -2 then the distance is 1 + abs(-2) = 3.
  // This means the base/eye of the camera is 3 units from the near plane.
  // </p>
  // <p>
  // This distance is required when performing backface culling. If the eye
  // is too close or too far then the culling culls early or late.
  // </p>
  // @return
  // The absolute distance from the near plane to camera/eye base.
  double getViewDistance() {
    return 1.0 + near.abs();
  }
}
