import 'package:flutter/material.dart';

/// Generic class to provide values for consumers
abstract class ConsumerPattern<T extends ChangeNotifier, V> extends StatefulWidget {

  /// Value provider reference
  final T provider;

  /// Funtion to build the user interface represented by this consumer.
  final Widget Function(BuildContext context, V value) builder;
  
  ConsumerPattern({Key key, @required this.provider, @required this.builder}) : super(key: key);

  /// Get value from value provider
  V getValue(BuildContext context, ConsumerPatternState consumer);

  @override
  ConsumerPatternState createState() => ConsumerPatternState<T, V>();
}

/// Class to maintain `Consumer` state
class ConsumerPatternState<T extends ChangeNotifier, V> extends State<ConsumerPattern<T, V>> {

  /// Reference of current value provider
  T _provider;
  /// Get the reference of current value provider
  T get provider => _provider;

  /// Value of the last value change notification from the value provider
  V _value;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_provider == null) {    
      _provider = widget.provider;
      _value = widget.getValue(context, this);
      _provider.addListener(_listener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_listener);
    super.dispose();
  }

  /// Event to get current value of value provider and call [setState] to rebuild widget
  void _listener() {
    setState(() {
      _value = widget.getValue(context, this);
    });
  }
}