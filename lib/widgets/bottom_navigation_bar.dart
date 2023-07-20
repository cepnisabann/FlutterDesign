import 'package:design/pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../pages/storepage.dart';

class GlobalBottomNavigationBar extends StatefulWidget {
  final int initialIndex;

  GlobalBottomNavigationBar({this.initialIndex = 0});

  @override
  _GlobalBottomNavigationBarState createState() =>
      _GlobalBottomNavigationBarState();
}

class _GlobalBottomNavigationBarState extends State<GlobalBottomNavigationBar> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        ); // Replace this with your desired action for index 0
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const StorePage(),
          ),
        );
        break;
      // Add cases for other indexes if needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _onItemTapped,
      currentIndex: _currentIndex,
      showSelectedLabels: true,
      elevation: 0,
      showUnselectedLabels: true,
      iconSize: 28,
      unselectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.black),
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.orange.shade800,
      unselectedIconTheme: IconThemeData(color: Colors.black),
      selectedIconTheme: IconThemeData(color: Colors.orange.shade400),
      selectedLabelStyle:
          TextStyle(fontSize: 12, color: Colors.orange.shade800),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.house_simple_light),
          label: 'Anasayfa',
        ),
        const BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.squares_four_light),
          label: 'Kategoriler',
        ),
        const BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.shopping_cart_light),
          label: 'Sepetim',
        ),
        const BottomNavigationBarItem(
          icon: Icon(
            CupertinoIcons.person,
          ),
          label: 'Hesabım',
        ),
      ],
    );
  }
}
