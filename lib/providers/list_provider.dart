import 'dart:async';

import 'package:flutter/material.dart';

class ListProvider<T> extends ChangeNotifier {
  List<T> _items = [];
  List<T> get items => _items;

  StreamController<List<T>> onInsert = StreamController<List<T>>();
  StreamController<List<T>> onRemove = StreamController<List<T>>();  

  ListProvider({List<T> initialItems}) {
    if (initialItems != null) {
      _items.addAll(initialItems);
    }
  }

  addItem(T item) => addItems([item]);
  addItemAt(int index, T item) => addItemsAt(index, [item]);
  addItems(List<T> items) {
    if (items.isNotEmpty) {
      _items.addAll(items);

      onInsert.add(items);
      notifyListeners();
    }
  }
  addItemsAt(int index, List<T> items) {
    if (items.isNotEmpty) {
      _items.insertAll(index, items);

      onInsert.add(items);
      notifyListeners();
    }
  }

  replaceItem(T item, T newItem) {
    int index = _items.indexOf(item);
    if (index >= 0) {
      replaceItemAt(index, newItem);
    } else {
      throw 'The item to be replaced not exist';
    }
  }
  replaceItemAt(int index, T newItem) {
    _items[index] = newItem;
    notifyListeners();
  }

  removeItem(T item) {
    if (_items.contains(item)) {
      _items.remove(item);

      onRemove.add([item]);
      notifyListeners();
    }
  }

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