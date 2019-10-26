import 'dart:async';

import 'package:flutter/material.dart';

/// Class to provide a list of defined objects for a `ListConsumer`
/// 
/// In the example below, a `ListProvider<String>` will be created to
/// maintain the movies list.
/// 
/// ```dart
/// ListProvider<String> movies = ListProvider<String>();
/// movies.addItem('Start Wars');
/// movies.addItem('Terminator');
/// movies.addItem('Total Recall');
/// ```
class ListProvider<T> extends ChangeNotifier {
  List<T> _items = [];

  /// Itens List
  List<T> get items => _items;

  /// StreamController to notify when an item is inserted in the list
  StreamController<List<T>> onInsert = StreamController<List<T>>();

  /// StreamController to notify when an item is removed from the list
  StreamController<List<T>> onRemove = StreamController<List<T>>();  

  ListProvider({List<T> initialItems}) {
    if (initialItems != null) {
      _items.addAll(initialItems);
    }
  }

  /// Add a new list item
  addItem(T item) => addItems([item]);
  
  /// Add a new list item at a specified position
  addItemAt(int index, T item) => addItemsAt(index, [item]);
  
  /// Add an item list
  addItems(List<T> items) {
    if (items.isNotEmpty) {
      _items.addAll(items);

      onInsert.add(items);
      notifyListeners();
    }
  }
  
  /// Add an item list at a specified position
  addItemsAt(int index, List<T> items) {
    if (items.isNotEmpty) {
      _items.insertAll(index, items);

      onInsert.add(items);
      notifyListeners();
    }
  }

  /// Replaces a list item
  replaceItem(T item, T newItem) {
    int index = _items.indexOf(item);
    if (index >= 0) {
      replaceItemAt(index, newItem);
    } else {
      throw 'The item to be replaced not exist';
    }
  }
  
  /// Replaces a list item at a specific position.
  replaceItemAt(int index, T newItem) {
    _items[index] = newItem;
    notifyListeners();
  }

  /// Remove an item from the list.
  removeItem(T item) {
    if (_items.contains(item)) {
      _items.remove(item);

      onRemove.add([item]);
      notifyListeners();
    }
  }
  
  /// Remove a item in specific position from the list
  removeItemAt(int index) {
    if (_items.length > index) {
      T item = _items[index];
      removeItem(item);
    }
  }

  /// Clear list
  clear() {
    if (items.isNotEmpty) {
      items.clear();
      notifyListeners();
    }
  }

  @override
  dispose() {
    onInsert.close();
    onRemove.close();
    return super.dispose();
  }
}