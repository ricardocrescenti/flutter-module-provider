import 'package:flutter/widgets.dart';
import 'package:module_provider/patterns/module.dart';

class InheritedModule extends InheritedWidget {
  final Module module;
  InheritedModule({
    Key key, 
    @required this.module, 
    @required Widget child }) : super(key: key, child: child);
    
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}