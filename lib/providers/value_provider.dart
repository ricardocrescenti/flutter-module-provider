import 'package:flutter/foundation.dart';

class ValueProvider<T> extends ChangeNotifier {
  T _value;

  T get value => _value;
  set value(T newValue) => setValue(newValue);

  ValueProvider({T initialValue}) {
    value = initialValue;
  }

  setValue(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}