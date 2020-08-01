import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/useful_classes.dart';

/// Class to implement constructors for use in `InjectManager`.
/// 
/// This class is currently being used to initialize module services in `services` of [Module].
class Inject<T extends OnDispose> {

  /// Default function for creating object.
  final T Function(Module module) constructor;

  /// Initialize [Inject]
  Inject(this.constructor);
}