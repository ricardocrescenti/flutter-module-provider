import 'dart:async';

import 'package:flutter/foundation.dart';

/// Class to implement disposable in classes
abstract class Disposable {
  final StreamController<dynamic> _onDispose = StreamController.broadcast();
  Stream<dynamic> get onDispose => _onDispose.stream;
  
  @mustCallSuper
  dispose() {
    if (!_onDispose.isClosed) {
      _onDispose.add(this);
      _onDispose.close();
    }
  }
}