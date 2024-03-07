# Dart

- https://dart.dev/get-dart#stable-channel
- https://pub.dev/packages/sdl2/install

# Flutter and Dart
Installing Dart separately yields something different. You really should upgrade Dart via Flutter:

This issue is because of the dart version and by updating flutter the dart version won't update, the way for solving this is, first, you need to be on the dev or master channel,

```sh
flutter channel master
flutter upgrade
```

after that run ```flutter doctor -v``` as you see your dart is still an old one

in this step, you should update it manually, as the doc says Dart
