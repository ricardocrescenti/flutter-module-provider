import 'package:flutter/cupertino.dart';
import 'package:module_provider/module_provider.dart';

class RouterOutlet extends StatefulWidget {
  /// 
  final GlobalKey<NavigatorState> navigatorKey;  
  /// initial route
  final String initialRoute;
  /// Load the routes to use in this module
  final List<RouterPattern> routes;
  /// 
  final Widget Function(BuildContext context) builder;

  RouterOutlet({
    this.navigatorKey,
    @required this.initialRoute,
    @required this.routes,
    @required this.builder
  });

  @override
  State<StatefulWidget> createState() => _RouterOutletState();
}

class _RouterOutletState extends State<RouterOutlet> with RouterImplementation {
  GlobalKey<NavigatorState> navigatorKey;

  @override
  void initState() {
    super.initState();

    this.navigatorKey = widget.navigatorKey ?? GlobalKey<NavigatorState>();
    this.initialRoute = widget.initialRoute;
    loadRoutes(widget.routes);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
    //return navigador;
  }
}