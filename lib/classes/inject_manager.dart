import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/module_provider.dart';

/// Class for building and maintaining instances of the objects, will only be
/// kept in memory if the [standalone] property is true.
class InjectManager<T extends OnDispose> {
  /// Indicates whether instances will be kept in memory
  final bool standalone;

  /// Lists of instances kept in memory
  final List<T> _instances = [];
  
  InjectManager({this.standalone = true});

  /// Get the instance of an object, if it is not instantiated, the object will be created and returned to its instance.
  T getInstance<P extends T>(Module module, dynamic args, List<Inject<T>> constructors, {T Function() nullInstance}) {
    T instance;

    _instances.forEach((item) {
      if (item is P) {
        instance = item;
      }
    });

    if (instance == null && constructors != null && constructors.isNotEmpty) {
      Inject inject = constructors.firstWhere((item) => item.constructor is P Function(Module module, List<dynamic> args), orElse: () => null); 
      if (inject != null) {
        instance = inject.constructor(module, args);
        if (standalone) {
          instance.onDispose.listen((_) {
            _instances.remove(instance);
          });
          _instances.add(instance);
        }
      }
    }

    if (instance == null && nullInstance != null) {
      instance = nullInstance();
    }

    if (instance == null) {
      throw Exception('Undeclared $T in module $module.');
    }
    
    return instance;
  }

  /// Dispose all instances
  dispose(Function (T instance) instanceDispose) {
    _instances.forEach((instance) {
      instanceDispose(instance);
      instance.notifyDispose();
    });
    _instances.clear();
  }
}