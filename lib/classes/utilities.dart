import 'package:flutter/foundation.dart';

class Utilities {
  static bool inDebugMode = !kReleaseMode;

  static log(String log) {
    if (inDebugMode) {
      print('module_provider >>> ' + log);
    }
  }
}

