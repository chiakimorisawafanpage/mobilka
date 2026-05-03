import 'package:flutter/material.dart';

/// Observes nested tab [Navigator]s (analog of React Navigation `useFocusEffect`).
final RouteObserver<PageRoute<dynamic>> appRouteObserver =
    RouteObserver<PageRoute<dynamic>>();
