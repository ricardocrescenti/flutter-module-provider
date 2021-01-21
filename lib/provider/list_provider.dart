import 'dart:collection';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to provide a list of defined objects for a [ListConsumer]
/// 
/// In the example below, a [ListProvider] os type [String] will be created to
/// maintain the movies list.
/// 
/// ```dart
/// ListProvider<String> movies = ListProvider<String>();
/// movies.add('Start Wars');
/// movies.addAll([
///   'Terminator 2: Judgment Day',
///   'Total Recall'
/// ]);
/// ```
class ListProvider<E> extends ChangeNotifier with ListMixin<E> {

  /// List used to store the elements of [ListProvider]
  List<E> _list = List();

  /// Indicates whether listeners should be notified when the list changes.
  /// 
  /// This variable is used by the [_executeOperation] method to control which
  /// execution should notify existing users.
  bool _canNotifyListeners = true;

  /// Indicates whether listeners should be notified automatically when changing 
  /// the list
  final bool automaticNotifyListeners;

  @override
  int get length {
    return _list.length;
  }

  @override
  set length(int newLength) {
    _list.length = newLength;
  }

  @override
  operator [](int index) {
    return _list[index];
  }
  
  @override
  void operator []=(int index, E value) {
    _executeOperation(() => _list[index] = value);
  }

  /// [ListProvider] default constructor.
  /// 
  /// If you want to initialize [ListProvider] with a list of initial items, 
  /// use the parameter [initialItems].
  ListProvider({
    List<E> initialItems,
    this.automaticNotifyListeners = true
  }) {
    if (initialItems != null) {
      addAll(initialItems);
    }
  }

  @override
  void add(E element) {
    _executeOperation(() => super.add(element));
  }

  @override
  void addAll(Iterable<E> iterable) {
    _executeOperation(() => super.addAll(iterable));
  }

  @override
  void insert(int index, E element) {
    _executeOperation(() => super.insert(index, element));
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _executeOperation(() => super.insertAll(index, iterable));
  }

  @override
  void fillRange(int start, int end, [E fill]) {
    _executeOperation(() => super.fillRange(start, end, fill));
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _executeOperation(() => super.setAll(index, iterable));
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _executeOperation(() => super.setRange(start, end, iterable, skipCount));
  }

  @override
  void replaceRange(int start, int end, Iterable<E> newContents) {
    _executeOperation(() => super.replaceRange(start, end, newContents));
  }

  @override
  bool remove(Object element) {
    return _executeOperation(() => super.remove(element));
  }

  @override
  E removeAt(int index) {
    return _executeOperation(() => super.removeAt(index));
  }

  @override
  E removeLast() {
    return _executeOperation(() => super.removeLast());
  }

  @override
  void removeRange(int start, int end) {
    _executeOperation(() => super.removeRange(start, end));
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _executeOperation(() => super.removeWhere(test));
  }

  @override
  void clear() {
    _executeOperation(() => super.clear());
  }

  /// Removes all objects from this list; the length of the list becomes zero.
  /// 
  /// Throws an [UnsupportedError], and retains all objects, if this is a fixed-length list.
  void clearAddAll(Iterable<E> iterable) {
    _executeOperation(() {
      super.clear();
      super.addAll(iterable);
    });
  }

  /// This method is used to perform the operations of all methods that modify
  /// (insert, remove replace) the elements of [ListProvider].
  /// 
  /// Depending on the method used, it may be that he calls another internal method
  /// to make the changes, such as the [addAll] method that receives a list of
  /// objects, and internally executes the [add] method for each element, however
  /// the notification of the listeners it should occur only after inserting all
  /// the elements, and not every [add] executed.
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