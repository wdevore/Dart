import 'dart:ffi';

import 'package:sdl2/sdl2.dart';

class Font {
  Pointer<TtfFont> font = nullptr;
  final String fontPath;

  Font(this.fontPath);

  int create(int pointSize) {
    // Initialize SDL2_ttf
    int status = ttfInit();

    if (status < 0) {
      return -2;
    }

    font = TtfFontEx.open(fontPath, pointSize);

    if (font == nullptr) {
      return -1;
    }

    return 0;
  }

  void close() {
    font.close();
  }
}
