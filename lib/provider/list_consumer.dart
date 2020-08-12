import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to consume a [ListProvider].
/// 
/// In the example below, a [ListProvider<String>] will be consumed, and when
/// adding or removing an item in the list, the [builder] method is called, and
/// the layout will be updated.
/// 
/// Implementation of [ListProvider]:
/// 
/// ```dart
/// ListProvider<String> movies = ListProvider<String>();
/// movies.addItem('Start Wars');
/// movies.addItem('Terminator');
/// movies.addItem('Total Recall');
/// ```
/// 
/// Example of how to consume [ListProvider]:
/// 
/// ```dart
/// ListConsumer<String>(
///   list: movies,
///   builder: (context, list) {
///     return ListView.separated(
///       itemCount: list.length,
///       itemBuilder: (context, index) => Text(list[index]),
///       separatorBuilder: (context, index) => Container(),
///     );
///   }
/// );
/// ```
class ListConsumer<T> extends ConsumerPattern<ListProvider<T>, ListProvider<T>> {
  
  /// [ListProvider] instance that will provide the list.
  final ListProvider<T> list;

  /// Funtion to build the user interface represented by this consumer.
  final Widget Function(BuildContext context, ListProvider<T> list) builder;
  
  /// ValueConsumer initializer
  ListConsumer({
    Key key, 
    @required this.list, 
    @required this.builder}) : super(key: key, provider: list, builder: builder);

  /// Get all items of [list]
  @override
  ListProvider<T> getValue(BuildContext context, ConsumerPatternState consumer) {
    return this.list;
  }
}