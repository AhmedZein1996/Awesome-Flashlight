import 'dart:developer';

import 'package:torch_light/torch_light.dart';

class FlashService {
  // function for turning On FlashLight
  static Future<void> lightOn() async {
    try {
      await TorchLight.enableTorch();
      log("Turn On");
    } catch (e) {
      log("Error: $e");
    }
  }

  // Function for turning Off FlashLight
  static Future<void> lightOff() async {
    try {
      await TorchLight.disableTorch();
      log("Turn Off");
    } catch (e) {
      log("Error: $e");
    }
  }
}
