import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:love14/Controllers/theme_controller.dart';
import 'package:love14/env_loader.dart';
import 'package:love14/providers/auth_provider.dart';
import 'package:love14/services/firebase_service.dart';
import 'package:love14/screens/auth/login_screen.dart';
import 'package:love14/screens/auth/signup_screen.dart';
import 'package:love14/screens/home/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await EnvLoader.loadEnv();

  // Validate required environment variables
  final requiredEnvVars = [
    'API_KEY',
    'AUTH_DOMAIN',
    'PROJECT_ID',
    'STORAGE_BUCKET',
    'MESSAGING_SENDER_ID',
    'APP_ID',
  ];

  final missingVars = requiredEnvVars
      .where((key) => EnvLoader.get(key) == null)
      .toList();

  if (missingVars.isNotEmpty) {
    throw Exception(
      'Missing required environment variables: ${missingVars.join(", ")}. '
      'Please check your assets/env.txt file.',
    );
  }

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: EnvLoader.get('API_KEY')!,
      authDomain: EnvLoader.get('AUTH_DOMAIN')!,
      projectId: EnvLoader.get('PROJECT_ID')!,
      storageBucket: EnvLoader.get('STORAGE_BUCKET')!,
      messagingSenderId: EnvLoader.get('MESSAGING_SENDER_ID')!,
      appId: EnvLoader.get('APP_ID')!,
    ),
  );

  // Initialize FirebaseService
  FirebaseService().initialize();

  // Get shared preferences
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
      ],
      child: MyApp(seenOnboarding: seenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    // Set system UI style
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });

    return MaterialApp(
      title: 'Love14',
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
      themeMode: themeController.themeMode,
      debugShowCheckedModeBanner: false,
      home: const AuthenticationWrapper(),
    );
  }
}

/// Decides which screen to show based on auth state
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Still loading auth state
        if (authProvider.firebaseUser == null && authProvider.isLoading) {
          return const SplashScreen();
        }

        // Not authenticated - show login/signup
        if (!authProvider.isAuthenticated) {
          return const LoginScreen();
        }

        // Authenticated and has couple - show home
        if (authProvider.hasCouple) {
          return const HomeScreen();
        }

        // Authenticated but couple not found - this shouldn't happen in normal flow
        return const Scaffold(
          body: Center(
            child: Text('Error: No couple found. Please contact support.'),
          ),
        );
      },
    );
  }
}

/// Simple splash screen while loading
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading Love14...'),
          ],
        ),
      ),
    );
  }
}
