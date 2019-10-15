import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:module_provider/classes/utilities.dart';

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
  updateValue(String fieldName, dynamic newValue, {bool canNotifyListeners = true}) {
    if (!values.containsKey(fieldName)) {
      throw Exception('The field ($fieldName) dont exists in ValuesProvider.');
    }

    if (_values[fieldName] == newValue) {
      return;
    }

    _values[fieldName] = newValue;
    _isChanged = true;

    Utilities.log('Field $fieldName changed to $newValue');

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