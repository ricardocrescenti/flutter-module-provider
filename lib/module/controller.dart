import 'dart:async';

import 'package:flutter/material.dart';
import 'package:module_provider/util/logger.dart';
import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/useful_classes.dart';

/// The [Controller] is used together a [Component] to keep the logic and state
/// separate from the component, leaving  component solely responsible for the 
/// layout.
/// 
/// Basic example of [Controller] implementation:
/// 
/// ```dart
/// class MyController extends Controller {
///   Controller(Module module) : super(module);
/// }
/// ```
/// 
/// Read the [Component] documentation to understand how to link [Controller] with
/// [Component].
class Controller with OnDispose {

  /// Parent module of controller and component
  final Module module;

  /// List of [StreamSubscription] performed on the controller, when discarding
  /// the controller, they are automatically canceled.
  final List<StreamSubscription> streamsSubscriptions = [];

  /// Initialize [Controller]
  Controller(this.module) {
    logger.log('Controller ${this.runtimeType} created');
  }

  /// Controller initializer.
  /// 
  /// This method can be used to initialize something needed for your controller.
  /// 
  /// If you need to wait for something asynchronous, add `async` to the method,
  /// the component will show loading until the future method will be completed. 
  /// You can modify the loading of the component by overriding the 
  /// [Component.buildFutureAwaitWidget] method.
  /// 
  /// This method is called only once at component startup.
  initialize(BuildContext context) {}

  /// Called when the [Component] is discarded. All StreamSubscription will also 
  /// be canceled.
  @mustCallSuper
  dispose() {

    // cancel all streams subscriptions
    streamsSubscriptions.forEach((subsctiption) => subsctiption.cancel());

    notifyDispose();
    
    logger.log('Controller ${this.runtimeType} disposed');
  }
}