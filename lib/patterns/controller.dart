import 'dart:async';

import 'package:module_provider/classes/on_dispose.dart';
import 'package:module_provider/classes/utilities.dart';
import 'package:module_provider/module_provider.dart';

/// Class for create components controllers
abstract class Controller with OnDispose {
  final Module module;

  List<StreamSubscription> streamsSubscriptions = [];

  Controller(this.module) {
    Utilities.log('Controller ${this.runtimeType} initialized');
  }

  dispose() {
    streamsSubscriptions.forEach((subsctiption) => subsctiption.cancel());
    notifyDispose();
    
    Utilities.log('Controller ${this} disposed');
  }
}