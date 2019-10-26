import 'package:flutter/widgets.dart';
import 'package:module_provider/patterns/module.dart';

/// This class is used on `build()` method of the `Module` to pass the module
/// reference to its descendants
class InheritedModule extends InheritedWidget {
  final Module module;
  InheritedModule({
    Key key, 
    @required this.module, 
    @required Widget child }) : super(key: key, child: child);
    
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}