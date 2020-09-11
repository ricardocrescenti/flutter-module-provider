import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

/// Abstract class for implementing the route manager
abstract class ModuleRouteManager {

  /// Initial route.
  @protected
  String initialRoute = '/';

  /// List of routes.
  @protected
  final Map<String, ModuleRoute> routes = {};

  Navigator _navigator;
  Widget get navigator {
    if (_navigator == null) {
      _navigator = Navigator(
        initialRoute: this.initialRoute,
        onGenerateRoute: onGenerateRoute,
        observers: [ModuleRouteObserver(
          onPush: (route, _) => onChangeRoute(route),
          onReplace: (route, _) => onChangeRoute(route))
        ]
      );
    }
    return WillPopScope(
      onWillPop: () async => !await _navigatorState.maybePop(),
      child: _navigator
    );
  }

  NavigatorState _navigatorState;
  NavigatorState get navigatorState => _navigatorState;

  /// Load the list of [ModuleRoutePattern] passed in the [routes] parameter and
  /// convert it into a standard format for the route manager.
  @protected
  loadRoutes(List<ModuleRoutePattern> routes, {String parentUrl = ''}) {
    if (routes == null || routes.isEmpty) {
      return;
    }

    routes.forEach((route) {
      if (route is ModuleRouteGroup) {
        loadRoutes(route.routes, parentUrl: parentUrl + ((parentUrl.isEmpty || !parentUrl.endsWith('/')) && route.name.isNotEmpty ? '/' : '') + route.name);
      } else {
        this.routes[parentUrl + ((parentUrl.isEmpty || !parentUrl.endsWith('/')) && route.name.isNotEmpty ? '/' : '') + route.name] = route;
      }
    });
  }  
  
  /// Method that receives the route request and returns the page to show
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {

    /// Get route name
    String routeName = (!routeSettings.name.startsWith('/') ? '/' : '') + routeSettings.name;

    /// Get route
    ModuleRoute router = routes[routeName];

    /// If the requested route does not exist, an error will be issued
    if (router == null) {
      throw Exception('Invalid route \'$routeName\'');
    }

    /// Return [MaterialPageRoute] to create the page
    return MaterialPageRoute(builder: router.builder, settings: routeSettings);
  }
  
  onChangeRoute(Route route) {
    _navigatorState = route.navigator;
  }
}