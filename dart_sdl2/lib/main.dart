import 'dart:ffi';
import 'dart:math';
import 'package:dart_sdl2/palette/colors.dart';
import 'package:dart_sdl2/raster/raster_buffer.dart';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';

const gWinWidth = 160 * 4;
const gWinHeight = 120 * 4;
const scale = 2;

int main() {
  return pixelBuf();
}

int example1() {
  if (sdlInit(SDL_INIT_VIDEO) == 0) {
    var window = calloc<Pointer<SdlWindow>>();
    var renderer = calloc<Pointer<SdlRenderer>>();
    if (sdlCreateWindowAndRenderer(640, 480, 0, window, renderer) == 0) {
      var done = SDL_FALSE;
      while (done == SDL_FALSE) {
        var event = calloc<SdlEvent>();
        sdlSetRenderDrawColor(renderer.value, 0, 0, 0, SDL_ALPHA_OPAQUE);
        sdlRenderClear(renderer.value);
        sdlSetRenderDrawColor(renderer.value, 255, 255, 255, SDL_ALPHA_OPAQUE);
        sdlRenderDrawLine(renderer.value, 320, 200, 300, 240);
        sdlRenderDrawLine(renderer.value, 300, 240, 340, 240);
        sdlRenderDrawLine(renderer.value, 340, 240, 320, 200);
        sdlRenderPresent(renderer.value);
        while (sdlPollEvent(event) != 0) {
          if (event.type == SDL_QUIT) {
            done = SDL_TRUE;
          }
        }
        calloc.free(event);
      }
      sdlDestroyRenderer(renderer.value);
      sdlDestroyWindow(window.value);
    } else {}
    calloc.free(window);
    calloc.free(renderer);
    sdlQuit();
  }

  return 0;
}

int example2() {
  if (sdlInit(SDL_INIT_VIDEO) != 0) {
    print(sdlGetError());
    return -1;
  }
  var window = SdlWindowEx.create(
    title: 'draw triangle',
    w: 640,
    h: 480,
  );
  if (window == nullptr) {
    print(sdlGetError());
    sdlQuit();
    return -1;
  }
  var renderer = window.createRenderer(
      -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
  if (renderer == nullptr) {
    print(sdlGetError());
    window.destroy();
    sdlQuit();
    return -1;
  }
  var lines = <Point<double>>[
    Point(320, 200),
    Point(300, 240),
    Point(340, 240),
    Point(320, 200)
  ];
  var event = calloc<SdlEvent>();
  var running = true;
  while (running) {
    while (event.poll() != 0) {
      switch (event.type) {
        case SDL_QUIT:
          running = false;
          break;
        default:
          break;
      }
    }
    renderer
      ..setDrawColor(0, 0, 0, SDL_ALPHA_OPAQUE)
      ..clear()
      ..setDrawColor(255, 128, 0, SDL_ALPHA_OPAQUE)
      ..drawLines(lines)
      ..present();
  }
  event.callocFree();
  renderer.destroy();
  window.destroy();
  sdlQuit();

  return 0;
}

int pixelBuf() {
  // SDL init
  if (sdlInit(SDL_INIT_VIDEO) != 0) {
    print('Unable to initialize SDL: ${sdlGetError()}');
    return 1;
  }

  // create SDL window
  var window = SdlWindowEx.create(
      title: 'sdl2_pixelbuffer',
      w: gWinWidth * scale,
      h: gWinHeight * scale,
      flags: SDL_WINDOW_RESIZABLE);
  if (window == nullptr) {
    print("Unable to create window: ${sdlGetError()}");
    sdlQuit();
    return 1;
  }

  // create renderer
  var renderer = window.createRenderer(
      -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);

  if (renderer == nullptr) {
    print("Unable to create renderer: ${sdlGetError()}");
    window.destroy();
    sdlQuit();
    return 1;
  }
  renderer.setLogicalSize(gWinWidth, gWinHeight);

  RasterBuffer rb = RasterBuffer();

  int status = rb.create(renderer, gWinWidth, gWinHeight);
  if (status < 0) {
    print('Unable to create texture: ${sdlGetError()}');
    renderer.destroy();
    window.destroy();
    sdlQuit();
  }

  // create texture
  // var texture = renderer.createTexture(SDL_PIXELFORMAT_RGBA32,
  //     SDL_TEXTUREACCESS_STREAMING, gWinWidth, gWinHeight);

  // if (texture == nullptr) {
  //   print('Unable to create texture: ${sdlGetError()}');
  //   renderer.destroy();
  //   window.destroy();
  //   sdlQuit();
  // }

  // array of pixels
  // var texturePixels = calloc<Pointer<Uint32>>();
  // var texturePitch = calloc<Int32>();

  Colors colors = Colors();

  rb.begin();
  // texture.lock(nullptr, texturePixels, texturePitch);

  // update texture with new data. Upper left position (aka 0)
  rb.setPixelXY(colors.red, 0, 0);

  // Pointer<Uint32> bufferAddr = texturePixels.value;
  // setPixelByOffset(red, 0, bufferAddr);
  // setPixelXY(colors.red, 0, 0, bufferAddr);

  // Calc address offset to x,y position. Middle of screen
  // setPixelByOffset(
  //     green, gWinWidth * gWinHeight ~/ 2 + gWinWidth ~/ 2, bufferAddr);
  // setPixelXY(colors.green, gWinWidth ~/ 2 - 1, gWinHeight ~/ 2 - 1, bufferAddr);
  rb.setPixelXY(colors.green, gWinWidth ~/ 2 - 1, gWinHeight ~/ 2 - 1);

  // Top right8
  // setPixelByOffset(yellow, gWinWidth - 1, bufferAddr);
  // setPixelXY(colors.yellow, gWinWidth - 1, 0, bufferAddr);
  rb.setPixelXY(colors.yellow, gWinWidth - 1, 0);

  // Lower right
  // setPixelByOffset(blue, gWinWidth * gWinHeight - 1, bufferAddr);
  // setPixelXY(colors.white, gWinWidth - 1, gWinHeight - 1, bufferAddr);
  rb.setPixelXY(colors.white, gWinWidth - 1, gWinHeight - 1);

  // setPixelXY(colors.cyan, 1, 1, bufferAddr);
  rb.setPixelXY(colors.cyan, 1, 1);

  // texture.unlock();
  rb.end();

  // main loop
  var event = calloc<SdlEvent>();
  var running = true;
  while (running) {
    while (event.poll() != 0) {
      switch (event.type) {
        case SDL_QUIT:
          running = false;
          break;
        default:
          break;
      }
      // render on screen
      renderer
        ..clear()
        ..copy(rb.texture!)
        ..present();
    }
  }
  event.callocFree();

  // texture.destroy();
  rb.destroy();

  renderer.destroy();
  window.destroy();

  sdlQuit();

  return 0;
}

void setPixelXY(int color, int x, int y, Pointer<Uint32> bufferAddr) {
  int offset = x + (y * gWinWidth);
  Pointer<Uint32> posOffset = bufferAddr + offset;
  posOffset.value = color;
}

void setPixelByOffset(int color, int offset, Pointer<Uint32> bufferAddr) {
  Pointer<Uint32> posOffset = bufferAddr + offset;
  posOffset.value = color;
}