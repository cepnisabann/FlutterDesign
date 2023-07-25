import 'package:design/data/product_cubit.dart';
import 'package:design/repo/product_repository.dart';
import 'package:design/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'di/locator.dart';

Future<void> main() async {
  await setupDI();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => ProductCubit(
        getIt<ProductRepository>(),
      ),
    )
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RootPage(),
    );
  }
}
