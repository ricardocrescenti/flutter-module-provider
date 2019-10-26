import 'package:flutter/foundation.dart';

/// Utilitaries to use inside the module_provider package
class Utilities {
  /// Indicates if the app is running in debug mode
  static bool inDebugMode = !kReleaseMode;

  /// Print a log message if the application is in debug mode
  static log(String log) {
    if (inDebugMode) {
      print('module_provider >>> ' + log);
    }
  }
}

