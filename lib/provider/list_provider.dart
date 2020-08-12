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

  /// 
  List<E> _list = List();

  /// 
  bool _canNotifyListeners = true;

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

  /// 
  ListProvider({List<E> initialItems}) {
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

  /// 
  dynamic _executeOperation(Function operation) {
    bool canNotifyListeners = _canNotifyListeners;
    if (canNotifyListeners) {
      _stopListenersNotification();
    }
    dynamic result = operation();

    if (canNotifyListeners) {
      this.notifyListeners();
    }

    return result;
  }

  /// 
  void _stopListenersNotification() {
    _canNotifyListeners = false;
  }

  @override
  void notifyListeners() {
    _canNotifyListeners = true;
    super.notifyListeners();
  }
}

// getList() {
//   ListProvider list = ListProvider<String>();
//   list.add("");
//   list.addAll([
//     "",
//     ""
//   ]);

//   list[0] = "";

//   return list;
// }