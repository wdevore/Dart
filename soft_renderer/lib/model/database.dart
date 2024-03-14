import 'package:soft_renderer/geometry/object3d.dart';
import 'package:soft_renderer/geometry/wiremesh_object.dart';
import 'package:soft_renderer/illumination/global_illumination.dart';
import 'package:soft_renderer/illumination/light_base.dart';

enum Class {
  gouraud,
  flat,
  phong,
}

class Database {
  // Total vertices in database.
  int vertexCount = 0;
  int triCount = 0;

  List<Object3D> gObjects = [];

  GlobalIllumination gi = GlobalIllumination();

  List<LightBase> lights = [];

  void addObject(Object3D o) {
    // Track the vertex count
    vertexCount += o.vertices.length;

    // Track the face count
    if (o is WireMeshObject) {
      triCount += o.triangles.length;
    }

    gObjects.add(o);
  }

  Object3D? getObject(String name) {
    try {
      return gObjects.firstWhere((element) => element.name == name);
    } on StateError {
      return null;
    }
  }
}
