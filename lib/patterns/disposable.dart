import 'dart:async';

/// Class for implement disposable method
abstract class Disposable {
  final StreamController<dynamic> _onDispose = StreamController.broadcast();
  Stream<dynamic> get onDispose => _onDispose.stream;

  dispose() {
    if (!_onDispose.isClosed) {
      _onDispose.add(this);
      _onDispose.close();
    }
  }
}