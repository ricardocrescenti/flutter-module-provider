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

	/// Indicates whether listeners should be notified automatically when changing 
	/// the value
	final bool automaticNotifyListeners;

	/// ValuesProvider initializer
	ValuesProvider(this._values, {
		this.automaticNotifyListeners = true
	}) {
		this._values.forEach((key, value) => this._originalvalues[key] = value);
	}

	/// Set the value of a single field
	void setValue(dynamic fieldName, dynamic newValue, {bool canNotifyListeners = true}) {
		List<dynamic> hierarchyFields = (fieldName is List ? List.from(fieldName) : [fieldName]);

		dynamic currentValue = getValue(hierarchyFields);
		if (currentValue is ValueProvider) {
			currentValue = currentValue.value;
		}
		if (currentValue == newValue) {
			return;
		}

		_container(hierarchyFields, true, newValue);

		if (canNotifyListeners && automaticNotifyListeners) {
			notifyListeners();
		}
	}

	/// Set the value of multiple fields
	void setValues(Map<String, dynamic> newValues) {
		if (newValues == null) {
			throw Exception('The map containing new values cannot be null');
		}
		
		newValues.forEach((key, value) {
			setValue(key, value, canNotifyListeners: false);
		});
		

		if (automaticNotifyListeners) {
			notifyListeners();
		}
	}
	
	/// Get the single field value
	T getValue<T>(dynamic fieldName) {
		List<dynamic> hierarchyFields = (fieldName is List ? List.from(fieldName) : [fieldName]);
		dynamic currentValue = _container(hierarchyFields, false);

		if (currentValue is ValueProvider) {
			return currentValue.value;
		} else {
			return currentValue;
		}
	}
	
	/// Get value from tree map
	dynamic _container(List<dynamic> hierarchyFields, bool setValue, [dynamic newValue]) {
		dynamic lastContainer = _values;
		dynamic lastField;
		dynamic currentValue;

		for (int index = 0; index < hierarchyFields.length; index++) {
			lastField = hierarchyFields[index];

			if (lastContainer is Map) {

				if (!lastContainer.containsKey(lastField)) {
					throw Exception('The field ${hierarchyFields.join('.')} does not exists in ValuesProvider');
				}
				currentValue = lastContainer[lastField];
			
			} else if (lastContainer is List) {

				lastField = int.tryParse(lastField);
				if (lastField == null) {
					throw Exception('The position entered for field ${hierarchyFields.join('.')} must be a valid number');
				} else if (lastContainer.length < (lastField + 1)) {
					throw Exception('The position entered for the field ${hierarchyFields.join('.')} must be less than the current list size');
				}
				currentValue = lastContainer[lastField];

			} else if (lastContainer is ValuesProvider) {

				if (setValue) {
					return lastContainer.setValue(hierarchyFields.getRange(index, hierarchyFields.length).toList(), newValue);
				} else {
					return lastContainer.getValue(hierarchyFields.getRange(index, hierarchyFields.length).toList());
				}
			
			} else {

				throw Exception('The field ${hierarchyFields.join('.')} does not exists in ValuesProvider');

			}

			if (index < hierarchyFields.length - 1) {
				lastContainer = currentValue;
			}
		}

		if (setValue && newValue != (currentValue is ValueProvider ? currentValue.value : currentValue)) {

			if (currentValue is ValueProvider) {
				currentValue.value = newValue;
			} else {
				lastContainer[lastField] = newValue;
			}

			currentValue = newValue;

		}

		return currentValue;
	}

	/// Get the field's value provider, if the field's value is ValueProvider.
	ValueProvider<T> getValueProvider<T>(dynamic fieldName) {
		List<dynamic> hierarchyFields = (fieldName is List ? fieldName : [fieldName]);
		dynamic currentValue = _container(hierarchyFields, false);

		if (currentValue is ValueProvider) {
			return currentValue;
		} else {
			throw Exception('Field ${hierarchyFields.last} is not of type ValueProvider.');
		}
	}

	/// Get all values
	Map<String, dynamic> getValues({bool onlyChanged = false}) {
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

	void forceNotifyListeners() {
		notifyListeners();
	}
}