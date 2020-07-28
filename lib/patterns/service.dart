import 'dart:async';

import 'package:module_provider/classes/logger.dart';
import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/useful_classes.dart';

/// The `Service` provide functions and properties to components, submodules
/// and other services, he is created and maintained in memory until module be 
/// disposed.
/// 
/// In the example below, I declared the `darkMode` property of type` bool` 
/// that defines whether the app will be built in dark mode or not, wehen 
/// `changeDarkMode()` is called, the `darkMode` property is changed and 
/// `notifyListeners()` is called to notify all consumers.
/// 
/// You can notify the change of some value in the service, or you can declare
/// variables of type `ValueProvider`,` ValuesProvider` and `ListProvider` and
/// limit change notifications only to listeners who need to change.
/// 
/// ```dart
/// class AppService extends Service {
///   bool _darkMode = false;
///   bool get darkMode => _darkMode;
/// 
///   final ValueProvider<int> counter = ValueProvider(initialValue: 0);
/// 
///   AppService(Module module) : super(module);
/// 
///   changeDarkMode() {
///     _darkMode = !_darkMode;
///     notifyListeners();
///   }
/// 
///   incrementCounter() {
///     counter.value++;
///   }
/// }
/// ```
abstract class Service with OnDispose {
  /// Module that the service is registered
  final Module module;

  /// List of `StreamSubscription` used to register all subscriptions made,
  /// when discarding the service, they are automatically canceled.
  final List<StreamSubscription> streamsSubscriptions = [];

  Service(this.module) {
    logger.log('Service ${this.runtimeType} initialized');
  }

  /// Called when `Module` is permanently removed from the tree. Will also
  /// be canceled all StreamSubscription. 
  void dispose() {
    streamsSubscriptions.forEach((subsctiption) => subsctiption.cancel());
    notifyDispose();

    logger.log('Service ${this} disposed');
  }
}