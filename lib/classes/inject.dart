import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/module_provider.dart';

/// Class to implement constructors for use in `InjectManager`, and allow an
/// object to be built when needed.
class Inject<T> extends OnDispose {
  /// Default function for creating object
  final T Function(Module module, dynamic arg) constructor;

  Inject(this.constructor);
}