import 'package:flutter/material.dart';
import 'package:love14/Config/LoginScreen.dart';
import 'package:love14/Screens/home_screen.dart';
import 'package:love14/Views/OnboardingScreen.dart';
import 'package:love14/admin/AdminScreen.dart';

final Map<String, WidgetBuilder> routes = {
  // General Screens
  '/login': (context) => const LoginScreen(),
  '/admin': (context) => const AdminScreen(),
  '/home': (context) => const MainNavigationScreen(),
  '/onboarding': (context) => const OnboardingScreen(),
};
