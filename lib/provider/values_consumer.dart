import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to consume a [ValuesProvider].
/// 
/// In the example below, a [ValuesConsumer] will be consumed, and when
/// update any values, the [builder] method is called, and
/// the layout will be updated.
/// 
/// Implementation of [ValuesProvider]:
/// 
/// ```dart
/// ValuesProvider movie = ValuesProvider(initialValue: {
///   'name': 'Terminator 2: Judgment Day',
///   'director': 'James Cameron',
///   'year': 1991 
/// });
/// ```
/// 
/// Example of how to consume [ValuesProvider]:
/// 
/// ```dart
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
class ValuesConsumer extends ConsumerPattern<ValuesProvider, UnmodifiableMapView<String, dynamic>> {
  
  /// The instance of [ValuesProvider] that will provide values
  final ValuesProvider provider;

  /// Funtion to build the user interface represented by this consumer.
  final Widget Function(BuildContext context, UnmodifiableMapView<String, dynamic> values) builder;
  
  /// ValuesConsumer initializer
  ValuesConsumer({
    Key key,
    @required this.provider,
    @required this.builder});

  /// Get map with all values in [provider]
  @override
  UnmodifiableMapView<String, dynamic> getValue(BuildContext context, ConsumerPatternState consumer) {
    return UnmodifiableMapView(provider.values);
  }
}