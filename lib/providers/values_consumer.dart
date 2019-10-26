import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to consume a `ValuesProvider`.
/// 
/// {@tool sample}
/// 
/// In the example below, a `ValuesConsumer` will be consumed, and when
/// update any values, the `builder()` method is called, and
/// the layout will be updated.
/// 
/// ```dart
/// ValuesProvider movie = ValuesProvider(initialValue: {
///   'name': 'Terminator 2: Judgment Day',
///   'director': 'James Cameron',
///   'year': 1991 
/// });
/// movie.setValue('year', 1991);
/// movie.setValues({
///   'name': 'Star Wars: Episode IV - A New Hope',
///   'director': 'George Lucas',
///   'year': 1977 
/// });
/// 
/// ValuesConsumer<String>(
///   list: movie,
///   builder: (context, value) {
///     return Column(children: [
///       Text(value['name']),
///       Text(value['director']),
///       Text(value['year']),
///     ]);
///   }
/// );
/// ```
/// {@end-tool}
class ValuesConsumer extends Consumer<ValuesProvider, UnmodifiableMapView<String, dynamic>> {
  /// The instance of `ValuesProvider` that will provide values
  final ValuesProvider provider;

  /// Funtion to build the user interface represented by this consumer.
  final Widget Function(BuildContext context, UnmodifiableMapView<String, dynamic> value) builder;
  
  ValuesConsumer({
    Key key,
    @required this.provider,
    @required this.builder});

  @override
  UnmodifiableMapView<String, dynamic> getValue(BuildContext context, ConsumerState consumer) {
    return provider.values;
  }
}