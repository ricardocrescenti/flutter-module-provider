import 'package:flutter/material.dart';

import 'future_await_widget.dart';
import 'future_error_widget.dart';
import 'package:module_provider/module_provider.dart';

/// Widget to implement loading in [Module] and [Component] when `intialize`
/// is asynchronous.
class FutureWidget<T> extends StatefulWidget {
  final Future<T> Function(BuildContext context) future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context) awaitWidget;
  final Widget Function(BuildContext context, Object error) errorWidget;
  
  ///FutureWidget initializer
  FutureWidget({
    @required this.future,
    @required this.builder,
    this.awaitWidget,
    this.errorWidget,
  });

  @override
  State<StatefulWidget> createState() => _FutureWidgetState<T>();
}

/// Class to maintain `FutureWidget` state
class _FutureWidgetState<T> extends State<FutureWidget<T>> {
  @override
  Widget build(BuildContext context) {
    Future<T> future = widget.future(context);

    if (future == null) {
      return widget.builder(context, null);
    }

    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildAwaitWidget(context);
        } else if (snapshot.error != null) {
          return _buildErrorWidget(context, snapshot.error);
        } else {
          return widget.builder(context, snapshot.data);
        }
      }
    );
  }

  _buildAwaitWidget(BuildContext context) {
    return (widget.awaitWidget != null 
      ? widget.awaitWidget(context) 
      : FutureAwaitWidget());
  }

  _buildErrorWidget(BuildContext context, Object error) {
    return (widget.errorWidget != null 
      ? widget.errorWidget(context, error) 
      : FutureErrorWidget());
  }
}