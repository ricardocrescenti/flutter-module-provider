import 'dart:collection';

import 'package:flutter/foundation.dart';

class ValuesProvider extends ChangeNotifier {
  final Map<String, dynamic> _values;

  bool _isChanged = true;
  UnmodifiableMapView<String, dynamic> _unmodifiableValues;
  UnmodifiableMapView<String, dynamic> get values => _createUnmodifiableValues();

  ValuesProvider(this._values);

  updateValues(Map<String, dynamic> newValues) {
    if (newValues == null) {
      throw Exception('The map containing new values cannot be null');
    }
    
    newValues.forEach((key, value) {
      updateValue(key, value, canNotifyListeners: false);
    });
    
    notifyListeners();
  }
  updateValue(String fieldName, dynamic newValue, {bool canNotifyListeners}) {
    if (!values.containsKey(fieldName)) {
      throw Exception('The field ($fieldName) dont exists in ValuesProvider.');
    }

    _values[fieldName].value = newValue;
    _isChanged = true;

    if (canNotifyListeners) {
      notifyListeners();
    }
  }

  _createUnmodifiableValues() {
    if (_isChanged) {
      _unmodifiableValues = UnmodifiableMapView<String, dynamic>(_values);
      _isChanged = false;
    }
    return _unmodifiableValues;
  }
}