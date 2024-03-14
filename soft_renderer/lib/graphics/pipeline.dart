import 'package:soft_renderer/palette/colors.dart';

class Pipeline {
  int textColor = Colors().mattePurple;
  int fpsColor = Colors().glowRed;

  // FPS vars
  int elapse = 0;
  double aveElapse = 0.0;
  int accElapse = 0;
  int averageCountElapse = 1;

  // Viewport dimensions
  int viewPortHeight = 0;
  int viewPortWidth = 0;
}
