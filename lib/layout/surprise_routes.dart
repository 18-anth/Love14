import 'package:flutter/material.dart';
import 'package:love14/Screens/create_surprise_screen.dart';
import 'package:love14/Screens/my_prises_screen.dart';
import 'package:love14/Screens/surprise_view_screen.dart';
import 'package:love14/Screens/premium_plans_screen.dart';

class SurpriseRoutes {
  static const String create = '/surprise/create';
  static const String myPrises = '/surprise/my-prises';
  static const String view = '/surprise/view';
  static const String premium = '/surprise/premium';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case create:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => CreateSurpriseScreen(userId: userId),
          settings: settings,
        );

      case myPrises:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => MyPrisesScreen(userId: userId),
          settings: settings,
        );

      case view:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SurpriseViewScreen(
            surpriseId: args['surpriseId'] as String,
            isPublic: args['isPublic'] as bool? ?? false,
          ),
          settings: settings,
        );

      case premium:
        final userId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => PremiumPlansScreen(userId: userId),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Ruta no encontrada'),
            ),
          ),
          settings: settings,
        );
    }
  }
}

// Navigation helper
class SurpriseNavigator {
  static void goToCreate(BuildContext context, String userId) {
    Navigator.pushNamed(
      context,
      SurpriseRoutes.create,
      arguments: userId,
    );
  }

  static void goToMyPrises(BuildContext context, String userId) {
    Navigator.pushNamed(
      context,
      SurpriseRoutes.myPrises,
      arguments: userId,
    );
  }

  static void goToView(
    BuildContext context,
    String surpriseId, {
    bool isPublicView = true,
  }) {
    Navigator.pushNamed(
      context,
      SurpriseRoutes.view,
      arguments: {
        'surpriseId': surpriseId,
        'isPublicView': isPublicView,
      },
    );
  }

  static void goToPremium(BuildContext context, String userId) {
    Navigator.pushNamed(
      context,
      SurpriseRoutes.premium,
      arguments: userId,
    );
  }
}
