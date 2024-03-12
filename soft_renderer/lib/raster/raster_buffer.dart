// RasterBuffer provides a memory mapped RGBA and Z buffer
// This buffer must be blitted to another buffer, for example,
// PNG or display buffer (like SDL).
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'package:soft_renderer/geometry/raster_edge.dart';
import 'package:soft_renderer/palette/colors.dart';

class RasterBuffer {
  int width = 0;
  int height = 0;
  bool alphaBlending = false;
  int size = 0;

  // Pen colors
  int pixelColor = Colors().black;
  int clearColor = Colors().darkBlack;

  Pointer<SdlTexture>? texture;
  Pointer<Pointer<Uint32>> texturePixels = calloc<Pointer<Uint32>>();
  Pointer<Int32> texturePitch = calloc<Int32>();
  Pointer<Uint32>? bufferAddr;
  Pointer<Uint32>? posOffset;

  Rectangle<double>? clearRect;
  late Uint32List textureAsList;

  int create(Pointer<SdlRenderer> renderer, int width, int height) {
    this.width = width;
    this.height = height;

    // create texture
    texture = renderer.createTexture(
        SDL_PIXELFORMAT_RGBA32, SDL_TEXTUREACCESS_STREAMING, width, height);

    if (texture == nullptr) {
      return -1;
    }

    clearRect = Rectangle<double>(
      0,
      0,
      (width - 1).toDouble(),
      (height - 1).toDouble(),
    );

    size = width * height;

    return 0;
  }

  void begin() {
    texture?.lock(nullptr, texturePixels, texturePitch);
    bufferAddr = texturePixels.value;
    textureAsList = bufferAddr!.asTypedList(size);
  }

  void end() => texture?.unlock();

  void clear(Pointer<SdlRenderer> renderer) {
    // Slow manual iteration
    // for (var i = 0; i < width * height - 1; i++) {
    //   posOffset = bufferAddr! + i;
    //   posOffset?.value = clearColor;
    // }

    // A bit faster
    textureAsList.fillRange(0, size - 1, clearColor);

    // Doesn't work because this buffer uses pointers.
    // Kept for posterity.
    // renderer.setTarget(texture!);
    // renderer.setDrawColor(0xff, 0x00, 0x00, SDL_ALPHA_OPAQUE);
    // renderer.fillRect(clearRect);
    // renderer.setTarget(nullptr);
  }

  void setPixelXY(int color, int x, int y) {
    if (x < 0 || x > width || y < 0 || y > height) {
      return;
    }
    pixelColor = color;
    int offset = x + (y * width);
    posOffset = bufferAddr! + offset;
    posOffset?.value = pixelColor;
  }

  void setPixel(int x, int y) {
    if (x < 0 || x > width || y < 0 || y > height) {
      return;
    }
    int offset = x + (y * width);
    posOffset = bufferAddr! + offset;
    posOffset?.value = pixelColor;
  }

  void setPixelByOffset(int color, int offset) {
    pixelColor = color;
    posOffset = bufferAddr! + offset;
    posOffset?.value = pixelColor;
  }

  void destroy() {
    texture?.destroy();
  }

  // TODO port alphablending
  // void setPixel(int x, int y) {
  //   if (x < 0 || x > width || y < 0 || y > height) {
  //     return;
  //   }

  //   // https://en.wikipedia.org/wiki/Alpha_compositing Alpha blending section
  //   // Non premultiplied alpha
  //   if (alphaBlending) {
  //     // dst := pixels.RGBAAt(x, y)
  //     // src := PixelColor
  //     // A := float32(src.A) / 255.0
  //     // dst.R = uint8(float32(src.R)*A + float32(dst.R)*(1.0-A))
  //     // dst.G = uint8(float32(src.G)*A + float32(dst.G)*(1.0-A))
  //     // dst.B = uint8(float32(src.B)*A + float32(dst.B)*(1.0-A))
  //     // dst.A = 255
  //     // pixels.SetRGBA(x, y, dst)
  //   } else {
  //     // pixels.SetRGBA(x, y, PixelColor)
  //   }

  //   return;
  // }

  void drawLineAmmeraal(int xP, int yP, int xQ, int yQ) {
    var x = xP;
    var y = yP;
    var d = 0;

    var yInc = 1;
    var xInc = 1;
    var dx = xQ - xP;
    var dy = yQ - yP;

    if (dx < 0) {
      xInc = -1;
      dx = -dx;
    }
    if (dy < 0) {
      yInc = -1;
      dy = -dy;
    }

    // --------------------------------------------------------------------
    if (dy <= dx) {
      // The change is Y is smaller than X
      var m = dy << 1;
      var c = dx << 1;

      if (xInc < 0) {
        dx++;
      }

      // int col = 0;
      for (;;) {
        setPixel(x, y);
        // col += 3;

        if (x == xQ) {
          break;
        }

        // X is the major step axis
        x += xInc;
        d += m;
        if (d >= dx) {
          y += yInc;
          d -= c;
        }
      }
    } else {
      var c = dy << 1;
      var m = dx << 1;

      if (yInc < 0) {
        dy++;
      }

      // int col = 0;
      for (;;) {
        setPixel(x, y);
        // col += 3;

        if (y == yQ) {
          break;
        }

        // Y is the major step axis
        y += yInc;
        d += m;
        if (d >= dy) {
          x += xInc;
          d -= c;
        }
      }
    }
  }

  void fillTriangleAmmeraal(
      RasterEdge left, RasterEdge right, bool skipBottom, bool skipRight) {
    int lx = left.x;
    int ly = left.y;

    int rx = right.x;
    int ry = right.y;

    if (skipBottom) {
      var dy = 0;
      if (lx > rx) {
        dy = -1;
      }
      if (ly == (left.yBot - dy)) {
        return;
      }
    }

    for (var x = lx; x <= rx; x++) {
      setPixel(x, ly);
    }

    for (; left.step();) {
      lx = left.x;
      ly = left.y;

      // For slopes where dy > dx, ry needs to "catch up" to ly
      // because ly is changing on each step where ry isn't.
      for (; ry < ly;) {
        right.step();
        rx = right.x;
        ry = right.y;
      }

      if (skipBottom) {
        // If the "side" vertex is to the right then there isn't
        // a line to skip.
        var dy = 0;
        if (lx > rx) {
          dy = -1;
        }
        if (ly == (left.yBot - dy)) {
          return;
        }
      }

      // We always want to fill the scanline from left to right
      if (lx > rx) {
        var t = rx;
        rx = lx;
        lx = t;
      }

      // The last pixel may be shared with another edge. That edge
      // will render it. Thus the top-left rendering rule.
      if (skipRight) {
        rx--;
      }
      // Fill scanline
      for (var x = lx; x <= rx; x++) {
        setPixel(x, ly);
      }
    }
  }
}
