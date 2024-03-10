import 'dart:ffi';
import 'dart:math';

import 'package:sdl2/sdl2.dart';
import 'package:soft_renderer/raster/font.dart';

class Text {
  Pointer<SdlTexture> text = nullptr;
  Rectangle<double>? textRect;

  int create(String content, double posX, double posY, Font font,
      Pointer<SdlRenderer> renderer) {
    Pointer<SdlSurface> textSurface = nullptr;

    textSurface = font.font.renderUtf8Shaded(
        content,
        SdlColorEx.rgbaToU32(255, 128, 0, SDL_ALPHA_OPAQUE),
        SdlColorEx.rgbaToU32(64, 64, 64, SDL_ALPHA_OPAQUE));

    if (textSurface == nullptr) {
      return -1;
    }

    // Create texture from surface pixels
    text = renderer.createTextureFromSurface(textSurface);
    if (text == nullptr) {
      // print('Unable to create texture from rendered text!\n'
      //     'SDL2 Error: ${sdlGetError()}\n');
      return -1;
    }

    // Get text dimensions and set upper left position
    textRect = Rectangle<double>(
      posX,
      posY,
      textSurface.ref.w.toDouble(),
      textSurface.ref.h.toDouble(),
    );

    textSurface.free();

    return 0;
  }

  void draw(Pointer<SdlRenderer> renderer) {
    renderer.copy(text, dstrect: textRect);
  }
}
