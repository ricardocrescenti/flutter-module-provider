import 'package:flutter/foundation.dart';
import 'package:module_provider/module_provider.dart';

/// Class to provide a value for a [ValueConsumer]
/// 
/// In the example below, a [ValueProvider] of type [String] will be created to
/// maintain the movie name.
/// 
/// ```dart
/// ValueProvider<String> movieName = ValueProvider<String>(initialValue: 'Start Wars');
/// movieName.value = 'Terminator';
/// movieName.setValue('Total Recall');
/// ```
class ValueProvider<T> extends ChangeNotifier {

	/// Current value of [ValueProvider]
	T? _value;

	/// Get current value
	T? get value => _value;
	/// Set new value
	set value(T? newValue) => setValue(newValue);

	/// Checks whether the [ValueProvider] has value
	bool get hasValue => value != null;

	/// Indicates whether listeners should be notified automatically when changing 
	/// the value
	final bool automaticNotifyListeners;

	/// ValueProvider initializer
	ValueProvider({
		T? initialValue, 
		this.automaticNotifyListeners = true
	}) {
		value = initialValue;
	}

	/// Set new value
	void setValue(T? newValue) {
		if (_value != newValue) {
			_value = newValue;

			if (automaticNotifyListeners) {
				notifyListeners();
			}
		}
	}

	void forceNotifyListeners() {
		notifyListeners();
	}

}