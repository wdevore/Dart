import 'package:soft_renderer/geometry/object3d.dart';
import 'package:soft_renderer/geometry/triangle.dart';
import 'package:soft_renderer/geometry/triangle_edge.dart';
import 'package:soft_renderer/palette/wu_color.dart';

class WireMeshObject extends Object3D {
  late WuColor wuColor;

  // A simple visibility edge list
  final List<TriangleEdge> edges = [];

  // A face is a list of indices. Typically three
  final List<Triangle> triangles = [];

  WireMeshObject(int r, int g, int b) {
    int bg = mapColor(255, 255, 255);
    wuColor = WuColor(bg, color, 4);

    name = 'MeshObject';
  }

  Triangle addTriangle(int i1, int i2, int i3) {
    Triangle t = Triangle(i1 - 1, i2 - 1, i3 - 1);
    t.setCenter(vertices[t.i1], vertices[t.i2], vertices[t.i3]);
    t.calcNormal(vertices[t.i1], vertices[t.i2], vertices[t.i3]);

    triangles.add(t);

    return t;
  }

  int addEdge(EdgeStates perminence, EdgeStates visibility) {
    TriangleEdge e = TriangleEdge()..visibility = visibility;
    if (perminence == EdgeStates.perminent) {
      e.perminence = EdgeStates.perminent;
    }
    edges.add(e);

    return edges.length;
  }

  void resetEdgeList() {
    for (var edge in edges) {
      edge.face = EdgeStates.noFace;
    }
  }
}
