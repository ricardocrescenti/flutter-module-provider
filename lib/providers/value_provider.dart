import 'package:flutter/foundation.dart';

class ValueProvider<T> extends ChangeNotifier {
  T _value;

  T get value => _value;
  set value(T newValue) => updateValue(newValue);

  ValueProvider({T initialValue}) {
    value = initialValue;
  }

  updateValue(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}