import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class NestedNavigationService {
  final Map<String, Widget Function(BuildContext)> routes;
  final String initialRoute;
  final GlobalKey<NavigatorState> _navigatorKey;

  /// Creates a nested navigator service instance and initializes a [GlobalKey] for
  /// the built-in Navigator (see [navigator])
  /// Arguments:
  ///   - initialRoute: The String name of the route to be rendered initially.
  ///   - routes: A [Map] of string route names to their corresponding widget.
  NestedNavigationService({
    required this.initialRoute,
    required this.routes,
  }) : _navigatorKey = GlobalKey<NavigatorState>();

  /// Returns a [Navigator] widget to be used when you want to implement nested
  /// navigation.
  Navigator get navigator {
    return Navigator(
      key: _navigatorKey,
      initialRoute: initialRoute,
      // This might not even be needed. Remove if unnecessary...
      onGenerateInitialRoutes: (state, ir) {
        assert (routes.containsKey(ir));
        return [
          MaterialPageRoute(builder: (context) {
            return (routes[ir]!(context));
          })
        ];
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) {
          return (routes[settings.name]!(context));
        },
        settings: settings);
      },
    );
  }

  /// Gets the nearest NestedNavigationService from the context.
  /// Equivalent to running `context.read`.
  static NestedNavigationService getNearest(BuildContext context) {
    return context.read<NestedNavigationService>();
  }

  /// Push a new screen to the stack.
  Future<T?> push<T>({required String route, dynamic arguments}) {
    return _navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }

  /// Pop a screen from the stack
  void pop<T>([T? result]) {
    _navigatorKey.currentState!.pop(result);
  }

  /// Replaces the present route with a new one by calling pop to the old one first
  /// and then calling push.
  Future<T?> replace<T>({required String route, T? result}) {
    return _navigatorKey.currentState!.pushReplacementNamed(route, result: result);
  }

  /// Returns true if there are more routes that can be popped.
  /// Equivalent to running [Route.isFirst]
  bool get canPop => _navigatorKey.currentState!.canPop();
}
