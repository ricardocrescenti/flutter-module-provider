import 'package:flutter/widgets.dart';
import 'package:module_provider/module_provider.dart';

/// Class used to pass the module to the descendant widgets. 
/// 
/// It is currently used by the following widgets in this package:
/// 
/// * [Module]
/// * [Component]
/// 
/// To obtain the parent module, just execute the method below, if there is no
/// parent module in the context the method will return null.
/// 
/// ```dart
/// Module module = context.dependOnInheritedWidgetOfExactType<InheritedModule>()?.module;
/// ```
/// 
/// In the example below, the parent module will be obtained in a [StatefulWidget] 
/// using the `didChangeDependencies` method:
/// 
/// ```dart
/// class TestWidget extends StatefulWidget {
///   @override
///   State<StatefulWidget> createState() => _TestWidgetState();
/// }
/// 
/// class _TestWidgetState extends State<TestWidget> {
///   Module module;
/// 
///   @override
///   void didChangeDependencies() {
///     super.didChangeDependencies();
///     this.module = context.dependOnInheritedWidgetOfExactType<InheritedModule>()?.module;
///   }
/// 
///   @override
///   Widget build(BuildContext context) {
///     return Container();
///   }
/// }
/// ```
/// 
/// And in the example below, the parent module will be obtained in a [StatelessWidget] 
/// in the `build` method:
/// 
/// ```dart
/// class TestWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final Module module = context.dependOnInheritedWidgetOfExactType<InheritedModule>()?.module;
///     return Container();
///   }
/// }
/// ```
class InheritedModule extends InheritedWidget {
  
  /// Module reference that will be passed on to descendants.
  final Module module;

  /// Initialize [InheritedModule]
  InheritedModule({
    Key key, 
    @required this.module, 
    @required Widget child }) : super(key: key, child: child);
    
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}