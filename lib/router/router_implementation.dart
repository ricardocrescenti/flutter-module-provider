import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

abstract class RouterImplementation {
  @protected
  String initialRoute = '/';
  @protected
  final Map<String, Router> routes = {};

  Navigator _navigador;
  Widget get navigador {
    if (_navigador == null) {
      _navigador = Navigator(
        initialRoute: this.initialRoute,
        onGenerateRoute: onGenerateRoute,
        observers: [RouterObserver(
          onPush: (route, _) => onChangeRoute(route),
          onReplace: (route, _) => onChangeRoute(route))
        ]
      );
    }
    return WillPopScope(
      onWillPop: () async => !await _navigatorState.maybePop(),
      child: _navigador
    );
  }

  NavigatorState _navigatorState;
  NavigatorState get navigatorState => _navigatorState;

  @protected
  loadRoutes(List<RouterPattern> routes, {String parentUrl = ''}) {
    routes.forEach((route) {
      if (route is RouterGroup) {
        loadRoutes(route.routes, parentUrl: parentUrl + ((parentUrl.isEmpty || !parentUrl.endsWith('/')) && route.name.isNotEmpty ? '/' : '') + route.name);
      } else {
        this.routes[parentUrl + ((parentUrl.isEmpty || !parentUrl.endsWith('/')) && route.name.isNotEmpty ? '/' : '') + route.name] = route;
      }
    });
  }  
  
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {

    ///
    String routeName = (!routeSettings.name.startsWith('/') ? '/' : '') + routeSettings.name;

    /// 
    Router router = routes[routeName];

    ///
    if (router == null) {
      //TODO: Implementar a rota inválida
      return null;
    }

    //TODO: Implementar o canPush e canPop
    return MaterialPageRoute(builder: router.builder, settings: routeSettings);
  }
  
  onChangeRoute(Route route) {
    _navigatorState = route.navigator;
  }
}