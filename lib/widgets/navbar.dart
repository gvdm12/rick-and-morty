import 'package:flutter/material.dart';
import 'package:flutter_tz/models/notifier.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navbar extends StatelessWidget {
  void Function(int)? onTabChange;
  Navbar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 5, right: 5),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: GNav(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                iconSize: 25,
                gap: 1,
                color: Colors.grey,
                activeColor: Colors.white,
                tabBackgroundColor: Colors.black,
                mainAxisAlignment: MainAxisAlignment.center,
                tabBorderRadius: 12,
                tabActiveBorder: Border.all(color: Colors.white),
                onTabChange: (value) => onTabChange!(value),
                tabs: [
                  GButton(icon: Icons.list_sharp, text: 'Список', iconSize: 20),
                  GButton(icon: Icons.star, text: 'Избранное', iconSize: 20),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode);
              },
            ),
          ),
        ],
      ),
    );
  }
}
