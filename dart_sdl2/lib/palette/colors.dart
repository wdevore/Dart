import 'dart:typed_data';

class Colors {
  int white =
      ByteData.view(Uint8List.fromList([255, 255, 255, 0]).buffer).getUint32(0);
  int red =
      ByteData.view(Uint8List.fromList([255, 0, 0, 0]).buffer).getUint32(0);
  int green =
      ByteData.view(Uint8List.fromList([0, 255, 0, 0]).buffer).getUint32(0);
  int blue =
      ByteData.view(Uint8List.fromList([0, 0, 0, 255]).buffer).getUint32(0);
  int yellow =
      ByteData.view(Uint8List.fromList([255, 255, 0, 0]).buffer).getUint32(0);
  int cyan =
      ByteData.view(Uint8List.fromList([0, 255, 255, 0]).buffer).getUint32(0);
}
