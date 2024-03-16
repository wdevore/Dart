import 'package:soft_renderer/graphics/arcball.dart';
import 'package:soft_renderer/graphics/frustum.dart' as volume;
import 'package:soft_renderer/graphics/plane.dart' as graphics;
import 'package:soft_renderer/model/database.dart';
import 'package:soft_renderer/palette/colors.dart' as pallete;
import 'package:vector_math/vector_math.dart';

class Pipeline {
  int textColor = pallete.Colors().mattePurple;
  int fpsColor = pallete.Colors().glowRed;

  // FPS vars
  int elapse = 0;
  double aveElapse = 0.0;
  int accElapse = 0;
  int averageCountElapse = 1;

  // Viewport dimensions
  int viewPortHeight = 0;
  int viewPortWidth = 0;

  // Frustum representing viewing volume
  volume.Frustum frustum = volume.Frustum();

  // A database with visible objects marked
  Database db = Database();

  // This matrix represents a transform from Model-space all the way to
  // View-Volume space. It is the accumulation of all the transformations.
  Matrix4 modelToViewVolume = Matrix4.identity();

  // This matrix represents the transform from model-space to world-space. The
  // modelview matrix is stored in each object as each object potentially is
  // located somewhere in world-space.
  Matrix4 modelToWorldSpace = Matrix4.identity();

  // This matrix represents transforms from world-space to view-space. It is
  // set by getting the camera's transform matrix.
  // camera.getTransformMatrix();
  //
  // Note: we are talking about camera or view-space NOT view-volume-space.
  Matrix4 worldSpaceToViewSpace = Matrix4.identity();

  // This matrix represents the transform from view-space to view-volume-space.
  // This is usually the frustum.
  Matrix4 viewSpaceToViewVolume = Matrix4.identity();

  // This matrix represents the transform from view-volume to screen-space
  Matrix4 viewVolumeToScreenSpace = Matrix4.identity();

  // This is an accumulation matrix that contains the current transforms.
  Matrix4 transform = Matrix4.identity();

  // These are the vertices that have been transformed from the world-space
  // all the way to the view-volume space.
  final List<Vector3> transformVertices = [];

  // Preallocation buckets
  Vector3 v1 = Vector3.zero();
  Vector3 v2 = Vector3.zero();
  Vector3 v3 = Vector3.zero();
  Vector3 v4 = Vector3.zero();

  Vector3 normal = Vector3.zero();
  Vector3 n1 = Vector3.zero();
  Vector3 n2 = Vector3.zero();
  Vector3 n3 = Vector3.zero();

  Vector3 vr1 = Vector3.zero();
  Vector3 vr2 = Vector3.zero();
  Vector3 vr3 = Vector3.zero();

  Vector3 p0 = Vector3.zero();
  Vector3 p1 = Vector3.zero();
  Vector3 p2 = Vector3.zero();
  Vector3 p3 = Vector3.zero();
  Vector3 p4 = Vector3.zero();

  ArcBall camera = ArcBall();

  // Clipped 2D points
  Vector3 clP = Vector3.zero();
  Vector3 clQ = Vector3.zero();

  // World Clipping planes
  graphics.Plane worldPlaneX = graphics.Plane();

  Pipeline() {}
}
