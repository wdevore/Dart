import 'package:soft_renderer/geometry/line_object.dart';
import 'package:soft_renderer/model/database.dart';
import 'package:vector_math/vector_math.dart';

class Objects {
  static void addTripod(double scale, Database data) {
    LineObject o;
    Vector3 v = Vector3.zero();

    v.setValues(0.0, 0.05, 0.0);
    o = LineObject(255, 0, 0)
      ..name = "+X"
      ..addVertex(v);
    v.setValues(1.0 * scale, 0.05, 0.0);
    o.addVertex(v);
    data.addObject(o);

    v.setValues(0.0, 0.05, 0.0);
    o = LineObject(255, 255, 0)
      ..name = "-X"
      ..addVertex(v);
    v.setValues(-1.0 * scale, 0.05, 0.0);
    o.addVertex(v);
    data.addObject(o);

    v.setValues(0.0, 0.05, 0.0);
    o = LineObject(0, 255, 0)
      ..name = "+Z"
      ..addVertex(v);
    v.setValues(0.0, 0.05, 1.0 * scale);
    o.addVertex(v);
    data.addObject(o);

    v.setValues(0.0, 0.05, 0.0);
    o = LineObject(0, 0, 0)
      ..name = "-Z"
      ..addVertex(v);
    v.setValues(0.0, 0.05, -1.0 * scale);
    o.addVertex(v);
    data.addObject(o);

    v.setValues(0.0, 0.05, 0.0);
    o = LineObject(0, 0, 255)
      ..name = "+Y"
      ..addVertex(v);
    v.setValues(0.0, 1.0 * scale, 0.0);
    o.addVertex(v);
    data.addObject(o);

    v.setValues(0.0, 0.05, 0.0);
    o = LineObject(255, 0, 255)
      ..name = "-Y"
      ..addVertex(v);
    v.setValues(0.0, -1.0 * scale, 0.0);
    o.addVertex(v);
    data.addObject(o);
  }
}
