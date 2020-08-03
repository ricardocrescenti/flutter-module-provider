import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to consume a [ValueProvider].
/// 
/// In the example below, a [ValueConsumer] os type [String] will be consumed, 
/// and when update value, the [builder] method is called, and the layout will
/// be updated.
/// 
/// Implementation of [ValueProvider]:
/// 
/// ```dart
/// ValueProvider<String> movieName = ValueProvider<String>(initialValue: 'Start Wars');
/// ```
/// 
/// Example of how to consume [ValueProvider]:
/// 
/// ```dart
/// ValueConsumer<String>(
///   value: movieName,
///   builder: (context, value) {
///     return Text(value);
///   }
/// );
/// ```
class ValueConsumer<T> extends ConsumerPattern<ValueProvider<T>, T> {

  /// ValueConsumer initializer
  ValueConsumer({
    Key key,
    @required ValueProvider<T>  provider,
    @required Widget Function(BuildContext context, T value) builder}) : super(key: key, provider: provider, builder: builder);

  /// Get current value from [provider]
  @override
  T getValue(BuildContext context, ConsumerPatternState consumer) {
    return provider.value;
  }
}