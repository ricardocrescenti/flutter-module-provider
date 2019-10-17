import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:module_provider/classes/utilities.dart';
import 'package:module_provider/module_provider.dart';

class ValuesProvider extends ChangeNotifier {
  final Map<String, dynamic> _values;

  bool _isChanged = true;
  UnmodifiableMapView<String, dynamic> _unmodifiableValues;
  UnmodifiableMapView<String, dynamic> get values => _createUnmodifiableValues();

  ValuesProvider(this._values);

  setValues(Map<String, dynamic> newValues) {
    if (newValues == null) {
      throw Exception('The map containing new values cannot be null');
    }
    
    newValues.forEach((key, value) {
      setValue(key, value, canNotifyListeners: false);
    });
    
    notifyListeners();
  }
  setValue(String fieldName, dynamic newValue, {bool canNotifyListeners = true}) {
    _validadeIfFieldExists(fieldName);

    dynamic currentValue = _values[fieldName];
    if (currentValue is ValueProvider) {
      currentValue = currentValue.value;
    }

    if (currentValue == newValue) {
      return;
    }

    if (_values[fieldName] is ValueProvider) {
      _values[fieldName].value = newValue;
    } else {
      _values[fieldName] = newValue;
    }
    
    _isChanged = true;

    Utilities.log('Field $fieldName changed to $newValue');

    if (canNotifyListeners) {
      notifyListeners();
    }
  }

  getValue(String fieldName) {
    _validadeIfFieldExists(fieldName);

    dynamic currentValue = _values[fieldName];
    if (currentValue is ValueProvider) {
      return currentValue.value;
    } else {
      return currentValue;
    }
  }
  getValueProvider(String fieldName) {
    _validadeIfFieldExists(fieldName);

    dynamic currentValue = _values[fieldName];
    if (currentValue is ValueProvider) {
      return currentValue;
    } else {
      throw Exception('Field $fieldName is not of type ValueProvider.');
    }
  }

  _validadeIfFieldExists(String fieldName) {
    if (!values.containsKey(fieldName)) {
      throw Exception('The field ($fieldName) dont exists in ValuesProvider.');
    }
  }

  _createUnmodifiableValues() {
    if (_isChanged) {
      _unmodifiableValues = UnmodifiableMapView<String, dynamic>(_values.map((key, value) {
        return MapEntry(key, (value is ValueProvider ? value.value : value));
      }));
      _isChanged = false;
    }
    return _unmodifiableValues;
  }
}