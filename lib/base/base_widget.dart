import 'package:design/di/locator.dart';
import 'package:flutter/material.dart';

abstract class BaseState<T extends ChangeNotifier, P extends StatefulWidget>
    extends State<P> {
  T viewModel = getIt<T>();
  @override
  void initState() {
    viewModel.addListener(() {
      setState(() {});
    });
    super.initState();
  }
}
