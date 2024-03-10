import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:sdl2/sdl2.dart';
import 'package:soft_renderer/raster/font.dart';
import 'package:soft_renderer/raster/raster_buffer.dart';
import 'package:soft_renderer/raster/text.dart';
import 'package:soft_renderer/window.dart';

const gWinWidth = 160 * 4;
const gWinHeight = 120 * 4;
const scale = 1;

int main() {
  return run();
}

// NOTE: Not need
// int myEventFilter(Pointer<Uint8> running, Pointer<SdlEvent> event) {
//   switch (event.type) {
//     case SDL_QUIT:
//       running.value = 0;
//       break;
//     case SDL_KEYDOWN:
//       var keys = sdlGetKeyboardState(nullptr);
//       // aka backtick '`' key
//       if (keys[SDL_SCANCODE_GRAVE] != 0) {
//         running.value = 0;
//       }
//     default:
//       break;
//   }
//   return 1;
// }

int run() {
  Window window = Window(gWinWidth, gWinHeight, scale);

  int status = window.init();
  if (status == 1) {
    return status;
  }

  status = window.create('Software renderer');
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

  font.close();

  // ---------------------------------------------
  // main loop
  // ---------------------------------------------
  var event = calloc<SdlEvent>();

  // var running = calloc<Uint8>();
  // running.value = 1;
  // sdlSetEventFilter(Pointer.fromFunction(myEventFilter, 0), running);

  var running = true;

  while (running) {
    int pollState = sdlPollEvent(event);

    // while (event.poll() != 0) {
    // while (pollState > 0) {
    if (pollState > 0) {
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
    // }
  }

  // running.callocFree();
  event.callocFree();

  rb.destroy();

  window.destroy();

  sdlQuit();

  return 0;
}
