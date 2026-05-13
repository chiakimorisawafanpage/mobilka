import 'package:flutter/material.dart';

/// Per-tab route observers (one per nested [Navigator]).
final RouteObserver<PageRoute<dynamic>> shopRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
final RouteObserver<PageRoute<dynamic>> cartRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
final RouteObserver<PageRoute<dynamic>> ordersRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
final RouteObserver<PageRoute<dynamic>> profileRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
final RouteObserver<PageRoute<dynamic>> adminRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
