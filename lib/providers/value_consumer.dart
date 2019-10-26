import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to consume a `ValueProvider`.
/// 
/// {@tool sample}
/// 
/// In the example below, a `ValueConsumer<String>` will be consumed, and when
/// update value, the `builder()` method is called, and the layout will be 
/// updated.
/// 
/// ```dart
/// ValueProvider<String> movieName = ValueProvider<String>(initialValue: 'Start Wars');
/// movieName.value = 'Terminator';
/// movieName.setValue('Total Recall');
/// 
/// /// example for consume movieName
/// ValueConsumer<String>(
///   value: movieName,
///   builder: (context, value) {
///     return Text(value);
///   }
/// );
/// ```
/// {@end-tool}
class ValueConsumer<T> extends Consumer<ValueProvider<T>, T> {
  /// The instance of `ValueProvider` that will provide value
  final ValueProvider<T> provider;

  /// Funtion to build the user interface represented by this consumer.
  final Widget Function(BuildContext context, T value) builder;
  
  ValueConsumer({
    Key key,
    @required this.provider,
    @required this.builder}) : super(key: key);

  @override
  T getValue(BuildContext context, ConsumerState consumer) {
    return provider.value;
  }
}