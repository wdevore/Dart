import 'dart:math';

import 'package:soft_renderer/palette/colors.dart';

// Wu anti-aliased coloring
class WuColor {
  List<int> wuIntensities = List.empty();
  int color = Colors().black;
  int intensityBits = 40;
  int numIntensityLevels = 0;

  void setIntensityBits(int numberOfBits) {
    intensityBits = numberOfBits;
    numIntensityLevels = pow(2, intensityBits).toInt();
  }

  WuColor(int backgroundColor, int lineColor, int intensityBits) {
    color = lineColor;

    setIntensityBits(intensityBits);

    wuIntensities = List.filled(numIntensityLevels, 0);

    double bcR = ((backgroundColor & 0x00ff0000) >> 16).toDouble();
    double bcG = ((backgroundColor & 0x0000ff00) >> 8).toDouble();
    double bcB = ((backgroundColor & 0x000000ff)).toDouble();

    double lcR = ((lineColor & 0x00ff0000) >> 16).toDouble();
    double lcG = ((lineColor & 0x0000ff00) >> 8).toDouble();
    double lcB = ((lineColor & 0x000000ff)).toDouble();

    // Color ratio = (background - linecolor)/NumLevels
    double crR = (bcR - lcR) / numIntensityLevels;
    double crG = (bcG - lcG) / numIntensityLevels;
    double crB = (bcB - lcB) / numIntensityLevels;

    int cr, cg, cb;

    for (double i = 1.0; i < numIntensityLevels + 1; i += 1.0) {
      cr = (lcR + (crR * i)).toInt();
      cg = (lcG + (crG * i)).toInt();
      cb = (lcB + (crB * i)).toInt();
      wuIntensities[(i - 1).toInt()] = (cr << 16) | (cg << 8) | (cb);
    }
  }
}
