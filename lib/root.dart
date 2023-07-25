import 'package:design/pages/homepage.dart';
import 'package:design/pages/storepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [HomePage(), StorePage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          showSelectedLabels: true,
          elevation: 0,
          showUnselectedLabels: true,
          iconSize: 28,
          unselectedLabelStyle:
              const TextStyle(fontSize: 12, color: Colors.black),
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.orange.shade800,
          unselectedIconTheme: const IconThemeData(color: Colors.black),
          selectedIconTheme: IconThemeData(color: Colors.orange.shade400),
          onTap: (value) => setState(() {
                currentIndex = value;
              }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.house_simple_light),
              label: 'Anasayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.squares_four_light),
              label: 'Kategoriler',
            ),
            BottomNavigationBarItem(
              icon: Icon(PhosphorIcons.shopping_cart_light),
              label: 'Sepetim',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.person,
              ),
              label: 'Hesabım',
            ),
          ]),
    );
  }
}
