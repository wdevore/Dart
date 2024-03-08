import 'dart:ffi';
import 'dart:math';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'package:triangle_render/geometry/triangle.dart';
import 'package:triangle_render/raster/font.dart';
import 'package:triangle_render/raster/raster_buffer.dart';
import 'package:triangle_render/raster/text.dart';
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
    window.destroy();
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

  String fontPath = 'MontserratAlternates-Light.otf';

  Font font = Font(fontPath);
  status = font.create(10);

  if (status == -1) {
    print('SDL2_ttf Error: ${ttfGetError()}\n');
    window.destroy();
    sdlQuit();
    return status;
  }

  Text text = Text();

  status = text.create('Hello world!', 10.0, 10.0, font, window.renderer!);
  if (status == -1) {
    print('SDL2 Error: ${ttfGetError()}\n');
    font.close();
    window.destroy();
    sdlQuit();
    return status;
  }

  // main loop
  var event = calloc<SdlEvent>();

  var running = true;

  font.close();

  while (running) {
    while (event.poll() != 0) {
      switch (event.type) {
        case SDL_QUIT:
          running = false;
          break;
        case SDL_KEYDOWN:
          var keys = sdlGetKeyboardState(nullptr);
          // aka backtick '`' key
          if (keys[SDL_SCANCODE_GRAVE] != 0) {
            running = false;
          }
        default:
          break;
      }

      // Initialize renderer color white for the background
      // NOTE: can't be seen because raster buffer covers the
      // entire view.
      // window.renderer!.setDrawColor(0xff, 0xff, 0xff, SDL_ALPHA_OPAQUE);

      // Don't need to clear because raster buffer covers the view.
      // So use raster buffer clear instead.
      // window.clear();

      // -------------------------------
      // Draw to custom texture buffer
      // -------------------------------
      rb.begin();

      rb.clear(window.renderer!);

      tri.fill(rb);

      rb.end();

      window.renderer!.copy(rb.texture!);

      // window.renderer!.setDrawColor(0xff, 0x00, 0x00, SDL_ALPHA_OPAQUE);
      // window.renderer!.drawLine(Point(30, 30), Point(70, 70));

      // -------------------------------
      // Draw overlay text
      // -------------------------------
      text.draw(window.renderer!);

      // -------------------------------
      // Display buffer
      // -------------------------------
      window.renderer!.present();
    }
  }

  event.callocFree();

  rb.destroy();

  window.destroy();

  sdlQuit();

  return 0;
}
