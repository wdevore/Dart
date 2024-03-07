import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'package:triangle_render/geometry/triangle.dart';
import 'package:triangle_render/raster/raster_buffer.dart';
import 'package:triangle_render/window.dart';

const gWinWidth = 160 * 4;
const gWinHeight = 120 * 4;
const scale = 2;

int main() {
  return pixelBuf();
}

int pixelBuf() {
  Window window = Window(gWinWidth, gWinHeight, scale);

  int status = window.init();
  if (status == 1) {
    return status;
  }

  status = window.create('Triangle renderer');
  switch (status) {
    case -2:
      sdlQuit();
      return status;
    case -3:
      window.destroy();
      sdlQuit();
      return status;
  }

  RasterBuffer rb = RasterBuffer();

  status = rb.create(window.renderer!, gWinWidth, gWinHeight);
  if (status == -1) {
    print('Unable to create texture: ${sdlGetError()}');
    window.destroy;
    sdlQuit();
  }

  Triangle tri = Triangle()
    ..posX = 250
    ..posY = 200
    ..set(
      0,
      50,
      50,
      50,
      25,
      0,
    );

  rb.begin();

  tri.fill(rb);

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
        case SDL_KEYDOWN:
          var keys = sdlGetKeyboardState(nullptr);
          if (keys[SDL_SCANCODE_Q] != 0) {
            running = false;
          }
        default:
          break;
      }
      // render on screen
      window.renderer!
        ..clear()
        ..copy(rb.texture!)
        ..present();
    }
  }

  event.callocFree();

  rb.destroy();

  window.destroy();

  sdlQuit();

  return 0;
}
