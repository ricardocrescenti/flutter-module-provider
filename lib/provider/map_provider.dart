import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to provide a map of defined objects for a [MapConsumer]
/// 
/// In the example below, a [MapProvider] os type [int] and [String] will be created to
/// maintain the movies classification.
/// 
/// ```dart
/// MapProvider<String, String> movies = MapProvider<String, String>();
/// movies['a'] = 'Start Wars';
/// movies['b'] = 'Terminator';
/// movies['c'] = 'Total Recall';
/// ```
class MapProvider<K,V> extends ChangeNotifier with MapMixin<K,V> {

  	/// Map used to store the elements of [MapProvider]
	final Map<K,V> _map = {};

	@override
	Iterable<K> get keys => _map.keys;
  
	/// Indicates whether listeners should be notified when the map changes.
	/// 
	/// This variable is used by the [_executeOperation] method to control which
	/// execution should notify existing users.
	bool _canNotifyListeners = true;

	/// Indicates whether listeners should be notified automatically when changing 
	/// the map
	final bool automaticNotifyListeners;

	/// Indicates whether the values informed in MapProvider should be automatically 
	/// converted to other corresponding providers
	final bool automaticConvertValuesToProvider;

	/// [MapProvider] default constructor.
	/// 
	/// If you want to initialize [MapProvider] with a map, use the parameter 
	/// [initialMap].
	MapProvider({
		Map<K,V> initialMap,
		this.automaticNotifyListeners = true,
		this.automaticConvertValuesToProvider = false
	}) {
		if (initialMap != null) {
			addAll(initialMap);
		}
	}

  	@override
  	V operator [](Object key) {
		return _map[key];
	}
  
	@override
	void operator []=(K key, V value) {
		_executeOperation(() {

			if (!automaticConvertValuesToProvider) {
				_map[key] = value;
			} else {
				if (value is Map && !(value is MapProvider)) {
					_map[key] = MapProvider(
						initialMap: value, 
						automaticConvertValuesToProvider: automaticConvertValuesToProvider) as dynamic;
				} else if (value is ValuesProvider) {
					_map[key] = MapProvider(
						initialMap: value.values, 
						automaticConvertValuesToProvider: automaticConvertValuesToProvider) as dynamic;
				} else if (value is List && !(value is ListProvider)) {
					_map[key] = ListProvider<V>(
						initialItems: value as List<V>, 
						automaticConvertValuesToProvider: automaticConvertValuesToProvider) as dynamic;
				} else {
					_map[key] = value;
				}
			}

		});
	}
  
	@override
	void clear() {
		_executeOperation(() => _map.clear());
	}
  
	@override
	void addAll(Map<K, V> other) {
		_executeOperation(() => super.addAll(other));
	}

	@override
	V putIfAbsent(K key, V Function() ifAbsent) {
		return _executeOperation(() => super.putIfAbsent(key, ifAbsent));
	}

	@override
	V update(K key, V Function(V value) update, {V Function() ifAbsent}) {
		return _executeOperation(() => super.update(key, update, ifAbsent: ifAbsent));
	}

	@override
	void updateAll(V Function(K key, V value) update) {
		_executeOperation(() => super.updateAll(update));
	}

	@override
	void addEntries(Iterable<MapEntry<K, V>> newEntries) {
		_executeOperation(() => super.addEntries(newEntries));
	}

	@override
  	V remove(Object key) {
		return _executeOperation(() => _map.remove(key));
	}

	void removeWhere(bool test(K key, V value)) {
		return _executeOperation(() => super.removeWhere(test));
	}

	/// This method is used to perform the operations of all methods that modify
	/// (insert, remove, replace) the values of [MapProvider].
	/// 
	/// Depending on the method used, it may be that he calls another internal method
	/// to make the changes, such as the [addAll] method that receives a map, and 
	/// internally executes the `set` operation ([]=) for each element, however
	/// the notification of the listeners it should occur only after inserting all
	/// the elements, and not every `set` executed.
	dynamic _executeOperation(Function operation) {
		bool canNotifyListeners = _canNotifyListeners;
		if (canNotifyListeners) {
			_canNotifyListeners = false;
		}

		dynamic result = operation();

		if (canNotifyListeners && automaticNotifyListeners) {
			this.notifyListeners();
		}

		return result;
	}

	@override
	void notifyListeners() {
		_canNotifyListeners = true;
		super.notifyListeners();
	}

	void forceNotifyListeners() {
		notifyListeners();
	}
}