import 'package:design/root.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'di/locator.dart';

Future<void> main() async {
  await setupDI();

  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'tr_TR';
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RootPage(),
    );
  }
}
