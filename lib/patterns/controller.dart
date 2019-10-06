import 'dart:async';

import 'package:module_provider/classes/disposable.dart';
import 'package:module_provider/module_provider.dart';

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