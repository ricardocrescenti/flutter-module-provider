import 'dart:async';

import 'package:module_provider/classes/disposable.dart';
import 'package:scoped_model/scoped_model.dart';

class ListProvider<T> extends Model with Disposable {
  List<T> _items = [];
  List<T> get items => _items;

  StreamController<List<T>> onInsert = StreamController<List<T>>();
  StreamController<List<T>> onRemove = StreamController<List<T>>();  

  ListProvider({List<T> initialItems}) {
    if (initialItems != null) {
      _items.addAll(initialItems);
    }
  }

  insertItem(T item) => insertItems([item]);
  insertItemAt(int index, T item) => insertItemsAt(index, [item]);
  insertItems(List<T> items) {
    if (items.length > 0) {
      _items.addAll(items);

      onInsert.add(items);
      notifyListeners();
    }
  }
  insertItemsAt(int index, List<T> items) {
    if (items.length > 0) {
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
    _items.replaceRange(index, index, [newItem]);
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
    if (items.length > 0) {
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