//import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:module_provider/module_provider.dart';

/// Class to provide a values for a [ValuesConsumer]
/// 
/// In the example below, a [ValuesProvider] will be created to
/// maintain the movie information
/// 
/// ```dart
/// ValuesProvider movie = ValuesProvider(initialValue: {
///   'name': 'Terminator 2: Judgment Day',
///   'director': 'James Cameron',
///   'year': 1991 
/// });
/// ```
/// To set the values use the following methods:
/// 
/// - [setValue] (set the value of a single field)
/// - [setValues] (set the value of multiple fields)
/// 
/// To get the values use the following methods:
/// 
/// - [getValue] (get the single field value)
/// - [getValues] (get all field values)
/// - [getValueProvider] (get the field provider reference, if the field value is ValueProvider)
class ValuesProvider extends ChangeNotifier {

  /// Map with current values
  final Map<String, dynamic> _values;

  /// Map with original values, used to detect changed values
  Map<String, dynamic> _originalvalues = Map();

  /// Get current values
  Map<String, dynamic> get values => _values;

  /// Operator to get single value
  operator [](String fieldName) => values[fieldName];

  /// ValuesProvider initializer
  ValuesProvider(this._values) {
    this._values.forEach((key, value) => this._originalvalues[key] = value);
  }

  /// Set the value of a single field
  setValue(dynamic fieldName, dynamic newValue, {bool canNotifyListeners = true}) {
    List<dynamic> fieldNameList = (fieldName is List ? fieldName : [fieldName]);
    dynamic valuesContainer = _getValue(fieldNameList);

    dynamic currentValue = valuesContainer[fieldNameList.last];
    if (currentValue is ValueProvider) {
      currentValue = currentValue.value;
    }

    if (currentValue == newValue) {
      return;
    }

    if (valuesContainer[fieldNameList.last] is ValueProvider) {
      valuesContainer[fieldNameList.last].value = newValue;
    } else {
      valuesContainer[fieldNameList.last] = newValue;
    }

    if (canNotifyListeners) {
      notifyListeners();
    }
  }

  /// Set the value of multiple fields
  setValues(Map<String, dynamic> newValues) {
    if (newValues == null) {
      throw Exception('The map containing new values cannot be null');
    }
    
    newValues.forEach((key, value) {
      setValue(key, value, canNotifyListeners: false);
    });
    
    notifyListeners();
  }
  
  /// Get the single field value
  getValue(dynamic fieldName) {
    List<dynamic> fieldNameList = (fieldName is List ? fieldName : [fieldName]);
    dynamic valuesContainer = _getValue(fieldNameList);

    dynamic currentValue = valuesContainer[fieldNameList.last];
    if (currentValue is ValueProvider) {
      return currentValue.value;
    } else {
      return currentValue;
    }
  }
  
  /// Get value from tree map
  _getValue(List<dynamic> fieldNameList) {
    dynamic valuesContainer = _values;

    for (int index = 0; index < fieldNameList.length; index++) {

      if (valuesContainer is Map) {

        if (!valuesContainer.containsKey(fieldNameList[index])) {
          throw Exception('The field ${fieldNameList.join('.')} does not exists in ValuesProvider');
        }
      
      } else if (valuesContainer is List) {

        if (valuesContainer.length < (index + 1)) {
          throw Exception('The field ${fieldNameList.join('.')} does not exists in ValuesProvider');
        }

      }

      if (index == fieldNameList.length - 1) {
        return valuesContainer;
      } else {
        valuesContainer = valuesContainer[fieldNameList[index]];
      }
    }
  }

  /// Get the field's value provider, if the field's value is ValueProvider.
  getValueProvider(dynamic fieldName) {
    List<dynamic> fieldNameList = (fieldName is List ? fieldName : [fieldName]);
    dynamic valuesContainer = _getValue(fieldNameList);

    dynamic currentValue = valuesContainer[fieldNameList.last];
    if (currentValue is ValueProvider) {
      return currentValue;
    } else {
      throw Exception('Field ${fieldNameList.last} is not of type ValueProvider.');
    }
  }

  /// Get all values
  getValues({bool onlyChanged = false}) {
    assert(onlyChanged != null);

    if (onlyChanged) {
      Map<String, dynamic> changedValues = Map();
      _values.forEach((key, value) {
        if (_originalvalues[key] != value) {
          changedValues[key] = value;
        }
      });
      return changedValues;
    } else {
      return values;
    }
  }
}