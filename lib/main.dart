import 'package:design/pages/detailspage.dart';
import 'package:design/pages/loginpage.dart';
import 'package:design/pages/profilepage.dart';
import 'package:design/pages/storepage.dart';
import 'package:design/root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'di/locator.dart';
import 'model/product.dart';

bool isLogged = false;
Future<void> main() async {
  await setupDI();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  if (kDebugMode) {
    print("user: $user");
  }
  //if user is not logged in, go to login page
  if (user == null) {
    isLogged = false;
  } else {
    isLogged = true;
  }
  Intl.defaultLocale = 'tr_TR';
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginPage(),
        '/root': (context) => const RootPage(),
        '/store': (context) => const StorePage(),
        '/profile': (context) => const ProfilePage(),
        '/productDetail': (context) => DetailsPage(
              product: ModalRoute.of(context)!.settings.arguments as Product,
            ),
      },
      home: isLogged ? const RootPage() : const LoginPage(),
    );
  }
}
