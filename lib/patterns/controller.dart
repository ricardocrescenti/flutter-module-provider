import 'dart:async';

import 'package:flutter/material.dart';
import 'package:module_provider/classes/logger.dart';
import 'package:module_provider/module_provider.dart';
import 'package:useful_classes/useful_classes.dart';

/// The `Controller` is used together a `Component` to keep the logic and state
/// separate from the component, leaving  component solely responsible for the 
/// layout.
/// 
/// ```dart
/// class HomeController extends Controller {
///   final ValueProvider<int> counter = ValueProvider(initialValue: 0);
/// 
///   HomeController(Module module) : super(module);
/// 
///   increment() {
///     counter.value++;
///   }
/// }
/// ```
class Controller with OnDispose {
  /// Module that the controller is registered
  final Module module;

  /// List of `StreamSubscription` used to register all subscriptions made,
  /// when discarding the controller, they are automatically canceled.
  final List<StreamSubscription> streamsSubscriptions = [];

  /// 
  Controller(this.module) {
    logger.log('Controller ${this.runtimeType} created');
  }

  /// 
  initialize(BuildContext context) {}

  Future futureInitialize(BuildContext context) => null;

  /// Called when `Component` is permanently removed from the tree. Will also
  /// be canceled all StreamSubscription. 
  @mustCallSuper
  dispose() {
    streamsSubscriptions.forEach((subsctiption) => subsctiption.cancel());
    notifyDispose();
    
    logger.log('Controller ${this.runtimeType} disposed');
  }
}