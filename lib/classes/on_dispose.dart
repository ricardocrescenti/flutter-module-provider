import 'dart:async';

import 'package:flutter/foundation.dart';

/// This class allows you to implement listeners notification when disposing 
/// object.
/// 
/// To notify listeners, create a `dispose()` method in your class and, after 
/// all objects are disposed, call `notifyDispose()`.
/// 
/// Sample `Dispose ()` method to use in your class
/// 
/// ```dart
/// dispose() {
///   notifyDispose();
/// }
/// ```
abstract class OnDispose {
  final StreamController<dynamic> _onDispose = StreamController.broadcast();
  Stream<dynamic> get onDispose => _onDispose.stream;
  
  /// Notify listeners with dispose of this object
  @mustCallSuper
  notifyDispose() {
    if (!_onDispose.isClosed) {
      _onDispose.add(this);
      _onDispose.close();
    }
  }
}