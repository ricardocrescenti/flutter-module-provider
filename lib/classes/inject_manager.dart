import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/classes/on_dispose.dart';

/// Class for building and maintaining instances of the objects.
class InjectManager<T extends OnDispose> with OnDispose {

  /// Initialized instance lists.
  final List<T> _instances = [];

  /// Get the instance of an object.
  /// 
  /// This method will first check if the instance of the requested type is 
  /// already created to return it, and if it is not already created, a constructor 
  /// that creates the instance will be consulted in [constructors].
  /// 
  /// If there is no constructor to create the requested instance, a method can
  /// be passed in [nullInstance] that makes a new attempt to create the instance, 
  /// this is used by [Module] to try to obtain this instance in the parent modules
  T getInstance<P extends T>(Module module, List<Inject<T>> constructors, {T Function() nullInstance}) {
    T instance;

    /// Check that an instance of the requested type has already been created
    _instances.forEach((item) {
      if (item is P) {
        instance = item;
      }
    });

    /// If the requested instance is not yet created and the constructor of the
    /// requested type exists in the list of constructors, the instance will be 
    /// created
    if (instance == null && constructors != null && constructors.isNotEmpty) {
      
      /// Find the requested type constructor
      Inject<T> inject = constructors.firstWhere((item) => item is P Function(Module module), orElse: () => null);

      /// If the constructor related to the requested type exists, the instance
      /// will be created and stored in memory
      if (inject != null) {
        instance = inject(module)
          ..onDispose.add((instance) {
            _instances.remove(instance);
          });
        _instances.add(instance);
      }
    
    }

    /// If the instance is not created (as there is no constructor of the
    /// requested type in the list of constructors) and it has a method to 
    /// be executed if the instance is not created, it will be called.
    if (instance == null && nullInstance != null) {
      instance = nullInstance();
    }

    /// 
    if (instance == null) {
      throw Exception('Undeclared $T in module $module.');
    }
    
    return instance;
  }

  /// Dispose all instances
  void dispose() {
    while (_instances.isNotEmpty) {
      _instances[0].dispose();
    }
    super.dispose();
  }
}