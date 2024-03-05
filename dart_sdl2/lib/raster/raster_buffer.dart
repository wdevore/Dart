// RasterBuffer provides a memory mapped RGBA and Z buffer
// This buffer must be blitted to another buffer, for example,
// PNG or display buffer (like SDL).
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';

class RasterBuffer {
  int width = 0;
  int height = 0;

  Pointer<SdlTexture>? texture;
  Pointer<Pointer<Uint32>> texturePixels = calloc<Pointer<Uint32>>();
  Pointer<Int32> texturePitch = calloc<Int32>();
  Pointer<Uint32>? bufferAddr;

  int create(Pointer<SdlRenderer> renderer, int width, int height) {
    this.width = width;
    this.height = height;

    // create texture
    texture = renderer.createTexture(
        SDL_PIXELFORMAT_RGBA32, SDL_TEXTUREACCESS_STREAMING, width, height);

    if (texture == nullptr) {
      print('Unable to create texture: ${sdlGetError()}');
      return -1;
    }

    return 0;
  }

  void begin() {
    texture?.lock(nullptr, texturePixels, texturePitch);
    bufferAddr = texturePixels.value;
  }

  void end() => texture?.unlock();

  void setPixelXY(int color, int x, int y) {
    int offset = x + (y * width);
    Pointer<Uint32> posOffset = bufferAddr! + offset;
    posOffset.value = color;
  }

  void setPixelByOffset(int color, int offset) {
    Pointer<Uint32> posOffset = bufferAddr! + offset;
    posOffset.value = color;
  }

  void destroy() {
    texture?.destroy();
  }
}
