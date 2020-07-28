import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/useful_classes.dart';

/// Class to implement constructors for use in `InjectManager`, and allow an
/// object to be built when needed.
class Inject<T> extends OnDispose {
  /// Default function for creating object
  final T Function(Module module) constructor;

  Inject(this.constructor);
}