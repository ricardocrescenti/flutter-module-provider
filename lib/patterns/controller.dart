import 'dart:async';

import 'package:useful_classes/useful_classes.dart';

/// Class for create components controllers
abstract class Controller with Disposable {
  List<StreamSubscription> streamsSubscriptions = [];

  @override
  dispose() {
    streamsSubscriptions.forEach((subsctiption) => subsctiption.cancel());
    super.dispose();
  }

}