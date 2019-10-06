import 'dart:async';

import 'package:flutter/foundation.dart';

/// Class to implement disposable in classes
abstract class OnDispose {
  final StreamController<dynamic> _onDispose = StreamController.broadcast();
  Stream<dynamic> get onDispose => _onDispose.stream;
  
  @mustCallSuper
  notifyDispose() {
    if (!_onDispose.isClosed) {
      _onDispose.add(this);
      _onDispose.close();
    }
  }
}