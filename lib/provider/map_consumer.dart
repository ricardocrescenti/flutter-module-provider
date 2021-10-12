import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to consume a [MapProvider].
/// 
/// In the example below, a [MapProvider<String, String>] will be consumed, and 
/// when adding or removing or updating an item in the map, the [builder] method 
/// is called, and the layout will be updated.
/// 
/// Implementation of [MapProvider]:
/// 
/// ```dart
/// MapProvider<String, String> movies = MapProvider<String, String>();
/// movies['a'] = 'Start Wars';
/// movies['b'] = 'Terminator';
/// movies['c'] = 'Total Recall';
/// ```
/// 
/// Example of how to consume [MapProvider]:
/// 
/// ```dart
/// MapConsumer<String>(
///   map: movies,
///   builder: (context, map) {
///     return Column(
///       children: [
///         Text(map['a']),
///         Text(map['b']),
///         Text(map['c']),
///       ],
///     );
///   }
/// );
/// ```
class MapConsumer<K,V> extends ConsumerPattern<MapProvider<K,V>, MapProvider<K,V>> {
  
  /// [MapProvider] instance that will provide the map.
  final MapProvider<K,V> map;

  /// Funtion to build the user interface represented by this consumer.
  final Widget Function(BuildContext context, MapProvider<K,V> map) builder;
  
  /// ValueConsumer initializer
  MapConsumer({
    Key key, 
    @required this.map, 
    @required this.builder}) : super(key: key, provider: map, builder: builder);

  /// Get all items of [Map]
  @override
  MapProvider<K,V> getValue(BuildContext context, ConsumerPatternState consumer) {
    return this.map;
  }
}