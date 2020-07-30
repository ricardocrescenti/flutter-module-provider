//import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:module_provider/util/logger.dart';
import 'package:module_provider/module_provider.dart';

/// Class to provide a values for a `ValuesConsumer`
/// 
/// In the example below, a `ValuesProvider` will be created to
/// maintain the movie information
/// 
/// ```dart
/// ValuesProvider movie = ValuesProvider(initialValue: {
///   'name': 'Terminator 2: Judgment Day',
///   'director': 'James Cameron',
///   'year': 1991 
/// });
/// 
/// /// to set new values
/// movie.setValue('year', 1991);
/// movie.setValues({
///   'name': 'Star Wars: Episode IV - A New Hope',
///   'director': 'George Lucas',
///   'year': 1977 
/// });
/// 
/// /// to get current values
/// movie.getValue('name');
/// ```
class ValuesProvider extends ChangeNotifier {
  final Map<String, dynamic> _values;
  Map<String, dynamic> _originalvalues = Map();

  //bool _isChanged = true;
  //UnmodifiableMapView<String, dynamic> _unmodifiableValues;

  /// Get current values
  //UnmodifiableMapView<String, dynamic> get values => _createUnmodifiableValues();
  Map<String, dynamic> get values => _values;

  /// Operator to get value
  operator [](String fieldName) => values[fieldName];

  ValuesProvider(this._values) {
    this._values.forEach((key, value) => this._originalvalues[key] = value);
  }

  /// Set new values
  setValues(Map<String, dynamic> newValues) {
    if (newValues == null) {
      throw Exception('The map containing new values cannot be null');
    }
    
    newValues.forEach((key, value) {
      setValue(key, value, canNotifyListeners: false);
    });
    
    notifyListeners();
  }
  
  /// Set new value to specifically field
  setValue(dynamic fieldName, dynamic newValue, {bool canNotifyListeners = true}) {
    List<dynamic> fieldNameList = (fieldName is List ? fieldName : [fieldName]);
    dynamic valuesContainer = _getValueContainer(fieldNameList);

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
    
    //_isChanged = true;

    logger.log('Field ${fieldNameList.join('.')} changed to $newValue');

    if (canNotifyListeners) {
      notifyListeners();
    }
  }

  /// Get de current value
  getValue(dynamic fieldName) {
    List<dynamic> fieldNameList = (fieldName is List ? fieldName : [fieldName]);
    dynamic valuesContainer = _getValueContainer(fieldNameList);

    dynamic currentValue = valuesContainer[fieldNameList.last];
    if (currentValue is ValueProvider) {
      return currentValue.value;
    } else {
      return currentValue;
    }
  }
  
  /// Get de currente Provider value
  getValueProvider(dynamic fieldName) {
    List<dynamic> fieldNameList = (fieldName is List ? fieldName : [fieldName]);
    dynamic valuesContainer = _getValueContainer(fieldNameList);

    dynamic currentValue = valuesContainer[fieldNameList.last];
    if (currentValue is ValueProvider) {
      return currentValue;
    } else {
      throw Exception('Field ${fieldNameList.last} is not of type ValueProvider.');
    }
  }

  /// Get values
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

  _getValueContainer(List<dynamic> fieldNameList) {
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

  // _createUnmodifiableValues() {
  //   if (_isChanged) {
  //     _unmodifiableValues = UnmodifiableMapView<String, dynamic>(_values.map((key, value) {
  //       return MapEntry(key, (value is ValueProvider ? value.value : value));
  //     }));
  //     _isChanged = false;
  //   }
  //   return _unmodifiableValues;
  // }
}