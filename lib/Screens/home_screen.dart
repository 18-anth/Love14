import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:love14/Config/LoginScreen.dart';

import 'package:love14/Screens/Flowers_screen.dart';
import 'package:love14/Screens/amapilla_screen.dart';
import 'package:love14/Screens/favorites_screen.dart';
import 'package:love14/Screens/notifications_screen.dart';
import 'package:love14/Screens/profile_screen.dart';
import 'package:love14/Screens/surprise_history_screen.dart';
import 'package:love14/Widgets/bottom_nav_bar.dart';
import 'package:love14/Widgets/custom_navigation_rail.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  User? _currentUser;
  bool _isLoading = true;

  static final List<Widget> _widgetOptions = <Widget>[
    AmapillaScreen(),
    FavoritesScreen(),
    Flowers(),
    NotificationsScreen(),
    const SurpriseHistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  void _checkUserLoggedIn() {
    // Obtener el usuario actual de Firebase Auth
    _currentUser = FirebaseAuth.instance.currentUser;

    // Si no hay usuario logueado, redirigir al login
    if (_currentUser == null) {
      // Redirigir al login después de que se construya el widget
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Mientras se verifica el usuario, mostrar loader o pantalla vacía
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Si el usuario está logueado, mostrar la pantalla principal
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
