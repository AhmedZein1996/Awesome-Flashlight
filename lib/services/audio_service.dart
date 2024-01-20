import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // // For Audio play
  // static final player = AudioPlayer();

  // audio
  static play(String audioSrc) async {
    final player = AudioPlayer();
    log("music played");
    await player.play(DeviceFileSource(audioSrc));
  }
}
