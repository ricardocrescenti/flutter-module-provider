import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Class to consume a `Service`.
/// 
/// {@tool sample}
/// 
/// In the example below, the `AppService` that is declared inside` AppModule`
/// will be consumed. It is not necessary to define the serice provider, as it
/// will automatically take service from the current module or the parent 
/// module.
/// 
/// ```dart
/// ServiceConsumer<AppService>(
///   builder: (context, service) {
///     //return Scaffold(....
///     //...
///   }
/// );
/// ```
/// {@end-tool}
class ServiceConsumer<T extends Service> extends Consumer<T, T> {
  /// Funtion to build the user interface represented by this consumer.
  final Widget Function(BuildContext context, T service) builder;

  ServiceConsumer({
    Key key,
    @required this.builder}) : super(key: key, builder: builder);

  @override
  T getProvider(BuildContext context, ConsumerState consumer) {
    return consumer.module.service<T>();
  }

  @override
  T getValue(BuildContext context, ConsumerState consumer) {
    return consumer.module.service<T>();
  }
}