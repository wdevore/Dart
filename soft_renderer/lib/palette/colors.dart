import 'dart:typed_data';

class Colors {
  final List<int> darkBlackC = [64, 64, 64, 255];
  final List<int> redC = [255, 0, 0, 255];
  final List<int> mattePurpleC = [128, 128, 200, 255];
  final List<int> glowRedC = [255, 64, 64, 255];

  late int darkBlack;
  late int black;
  late int mattePurple;
  late int glowRed;

  final int white =
      ByteData.view(Uint8List.fromList([255, 255, 255, 255]).buffer)
          .getUint32(0);
  late int red;
  final int green =
      ByteData.view(Uint8List.fromList([0, 255, 0, 255]).buffer).getUint32(0);
  final int blue =
      ByteData.view(Uint8List.fromList([0, 0, 0, 255]).buffer).getUint32(0);
  final int yellow =
      ByteData.view(Uint8List.fromList([255, 255, 0, 255]).buffer).getUint32(0);
  final int cyan =
      ByteData.view(Uint8List.fromList([0, 255, 255, 255]).buffer).getUint32(0);

  Colors() {
    black = convertRGBAtoUint8([0, 0, 0, 0]);
    darkBlack = convertRGBAtoUint8(darkBlackC);
    red = convertRGBAtoUint8(redC);
    mattePurple = convertRGBAtoUint8(mattePurpleC);
    glowRed = convertRGBAtoUint8(glowRedC);
  }

  static int convertRGBAtoUint8(List<int> rgba) {
    return ByteData.view(Uint8List.fromList(rgba).buffer).getUint32(0);
  }
}
