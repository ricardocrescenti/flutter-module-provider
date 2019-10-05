import 'package:scoped_model/scoped_model.dart';
import 'package:useful_classes/useful_classes.dart';

class ListProvider<T> extends Model with Disposable {
  List<T> _items = [];
  List<T> get items => _items;

  ValueBloc<List<T>> onInsert = ValueBloc<List<T>>();
  ValueBloc<List<T>> onRemove = ValueBloc<List<T>>();  

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

      onInsert.updateValue(items);
      notifyListeners();
    }
  }
  insertItemsAt(int index, List<T> items) {
    if (items.length > 0) {
      _items.insertAll(index, items);

      onInsert.updateValue(items);
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

      onRemove.updateValue([item]);
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
    onInsert.dispose();
    onRemove.dispose();
    return super.dispose();
  }
}