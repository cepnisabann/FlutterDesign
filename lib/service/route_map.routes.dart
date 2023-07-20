// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// RouteMapConfigGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:route_map/route_map.dart';
import 'package:design/pages/storepage.dart';

class RouteMaps {
  static String storePage = "/home";
}

Map<String, RouteModel> get routes => _routes;
final Map<String, RouteModel> _routes = {
  RouteMaps.storePage: RouteModel(
    (_) => const StorePage(),
  ),
};
Route? $onGenerateRoute(RouteSettings routeSettings,
        {String? Function(String routeName)? redirect}) =>
    mOnGenerateRoute(
      routeSettings,
      routes,
      redirect: redirect,
    );
