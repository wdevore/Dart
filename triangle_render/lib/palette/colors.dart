import 'dart:typed_data';

class Colors {
  final List<int> darkBlackC = [64, 64, 64, 0];
  final List<int> redC = [255, 0, 0, 0];

  late int darkBlack;

  final int black =
      ByteData.view(Uint8List.fromList([0, 0, 0, 0]).buffer).getUint32(0);
  final int white =
      ByteData.view(Uint8List.fromList([255, 255, 255, 0]).buffer).getUint32(0);
  late int red;
  final int green =
      ByteData.view(Uint8List.fromList([0, 255, 0, 0]).buffer).getUint32(0);
  final int blue =
      ByteData.view(Uint8List.fromList([0, 0, 0, 255]).buffer).getUint32(0);
  final int yellow =
      ByteData.view(Uint8List.fromList([255, 255, 0, 0]).buffer).getUint32(0);
  final int cyan =
      ByteData.view(Uint8List.fromList([0, 255, 255, 0]).buffer).getUint32(0);

  Colors() {
    darkBlack =
        ByteData.view(Uint8List.fromList(darkBlackC).buffer).getUint32(0);
    red = ByteData.view(Uint8List.fromList(redC).buffer).getUint32(0);
  }
}
