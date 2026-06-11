import 'package:flutter/material.dart';
import 'package:love14/Config/LoginScreen.dart';
import 'package:love14/Screens/home_screen.dart';
import 'package:love14/Views/OnboardingScreen.dart';
import 'package:love14/admin/AdminScreen.dart';
import 'package:love14/Screens/create_surprise_screen.dart';
import 'package:love14/Screens/surprise_view_screen.dart';
import 'package:love14/Screens/surprise_history_screen.dart';
import 'package:love14/Screens/premium_plans_screen.dart';

final Map<String, WidgetBuilder> routes = {
  // General Screens
  '/login': (context) => const LoginScreen(),
  '/admin': (context) => const AdminScreen(),
  '/home': (context) => const MainNavigationScreen(),
  '/onboarding': (context) => const OnboardingScreen(),

  // Surprise Screens
  '/create-surprise': (context) => const CreateSurpriseScreen(userId: ''),
  '/surprise-history': (context) => const SurpriseHistoryScreen(),
  '/premium-plans': (context) => const PremiumPlansScreen(userId: ''),
};

// Route with parameters (surprise-view needs surpriseId)
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/surprise-view':
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (context) => SurpriseViewScreen(
          surpriseId: args?['surpriseId'] ?? '',
          isPublic: args?['isPublic'] ?? false,
        ),
      );
    default:
      return MaterialPageRoute(
        builder: (context) =>
            routes[settings.name]?.call(context) ??
            const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
      );
  }
}
