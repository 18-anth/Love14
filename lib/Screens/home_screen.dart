import 'package:flutter/material.dart';
import 'package:love14/Screens/Flowers_screen.dart';
import 'package:love14/Screens/amapilla_screen.dart';
import 'package:love14/Screens/favorites_screen.dart';
import 'package:love14/Screens/notifications_screen.dart';
import 'package:love14/Screens/profile_screen.dart';
import 'package:love14/Widgets/bottom_nav_bar.dart';
import 'package:love14/Widgets/custom_navigation_rail.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    AmapillaScreen(),
    FavoritesScreen(),
    Flowers(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          if (isLargeScreen)
            CustomNavigationRail(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
        ],
      ),
      bottomNavigationBar:
          !isLargeScreen
              ? BottomNavBar(
                selectedIndex: _selectedIndex,
                onItemTapped: _onItemTapped,
              )
              : null,
    );
  }
}
