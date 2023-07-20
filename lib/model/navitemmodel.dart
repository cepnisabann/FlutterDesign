import 'package:flutter/material.dart';

class NavItemModel {
  NavItemModel({
    required this.icon,
    required this.label,
    required this.route,
    required this.key,
  });
  final IconData icon;
  final String label;
  final String route;
  final GlobalKey<NavigatorState> key;
}
