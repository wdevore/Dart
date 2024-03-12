import 'package:soft_renderer/geometry/object3d.dart';
import 'package:soft_renderer/palette/wu_color.dart';
import 'package:vector_math/vector_math.dart';

class LinesObject extends Object3D {
  late WuColor wuColor;

  LinesObject(int r, int g, int b) {
    color = mapColor(r, g, b);
    int bg = mapColor(255, 255, 255);
    wuColor = WuColor(bg, color, 4);

    name = 'LinesObject';
  }

  void addLine(
      double x1, double y1, double z1, double x2, double y2, double z2) {
    vertices.add(Vector3(x1, y1, z1));
    vertices.add(Vector3(x2, y2, z2));
  }
}
