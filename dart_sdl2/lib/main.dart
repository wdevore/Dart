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

  Colors colors = Colors();

  rb.begin();

  // update texture with new data. Upper left position (aka 0)
  rb.setPixelXY(colors.red, 0, 0);

  // Calc address offset to x,y position. Middle of screen
  rb.setPixelXY(colors.green, gWinWidth ~/ 2 - 1, gWinHeight ~/ 2 - 1);

  // Top right
  rb.setPixelXY(colors.yellow, gWinWidth - 1, 0);

  // Lower right
  rb.setPixelXY(colors.white, gWinWidth - 1, gWinHeight - 1);

  rb.setPixelXY(colors.cyan, 1, 1);

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

  rb.destroy();

  renderer.destroy();
  window.destroy();

  sdlQuit();

  return 0;
}
