import 'package:flutter/material.dart';
import 'package:module_provider/module_provider.dart';

abstract class RouterOperations {
  @protected
  final Map<String, Router> routes = {};

  Navigator _navigador;
  Widget get navigador {
    if (_navigador == null) {
      _navigador = Navigator(
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
        loadRoutes(route.routes, parentUrl: parentUrl + (parentUrl.isNotEmpty && route.name.isNotEmpty ? '/' : '') + route.name);
      } else {
        this.routes[parentUrl + (parentUrl.isNotEmpty && route.name.isNotEmpty ? '/' : '') + route.name] = route;
      }
    });
  }  
  
  @protected
  Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    Router router = routes[routeSettings.name];
    if (router == null) {
      //TODO: Implementar a rota inválida
      return null;
    }

    //TODO: Implementar o canPush e canPop
    return MaterialPageRoute(builder: router.builder, settings: routeSettings);
  }
  
  @protected
  onChangeRoute(Route route) {
    _navigatorState = route.navigator;
  }
}