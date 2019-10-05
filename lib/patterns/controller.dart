import 'dart:async';

import 'package:useful_classes/useful_classes.dart';

import '../module_provider.dart';

/// Class for create components controllers
abstract class Controller with Disposable {
  final Module module;

  List<StreamSubscription> streamsSubscriptions = [];

  Controller(this.module);

  @override
  dispose() {
    streamsSubscriptions.forEach((subsctiption) => subsctiption.cancel());
    super.dispose();
  }
}