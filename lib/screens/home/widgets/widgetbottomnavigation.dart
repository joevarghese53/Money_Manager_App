import 'package:flutter/material.dart';

import '../screenhome.dart';

class Bottomnavigation extends StatelessWidget {
  const Bottomnavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Homescreen.selectedindexnotifier,
      builder: (context, value, child) {
        return BottomNavigationBar(
            selectedItemColor: Colors.purple,
            currentIndex: value,
            onTap: (newindex) {
              Homescreen.selectedindexnotifier.value = newindex;
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'transactions'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'category')
            ]);
      },
    );
  }
}
