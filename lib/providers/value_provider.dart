import 'package:flutter/foundation.dart';

/// Class to provide a value for a `ValueConsumer`
/// 
/// In the example below, a `ValueProvider<String>` will be created to
/// maintain the movie name.
/// 
/// ```dart
/// ValueProvider<String> movieName = ValueProvider<String>(initialValue: 'Start Wars');
/// movieName.value = 'Terminator';
/// movieName.setValue('Total Recall');
/// ```
class ValueProvider<T> extends ChangeNotifier {
  T _value;

  /// Get current value
  T get value => _value;
  /// Set new value
  set value(T newValue) => setValue(newValue);

  ValueProvider({T initialValue}) {
    value = initialValue;
  }

  /// Set new value
  setValue(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}