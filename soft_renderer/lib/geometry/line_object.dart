import 'package:soft_renderer/geometry/object3d.dart';
import 'package:soft_renderer/palette/wu_color.dart';

class LineObject extends Object3D {
  late WuColor wuColor;

  LineObject(int r, int g, int b) {
    color = mapColor(r, g, b);
    int bg = mapColor(255, 255, 255);
    wuColor = WuColor(bg, color, 4);
    name = 'LineObject';
  }
}
