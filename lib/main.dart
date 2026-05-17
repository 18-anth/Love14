import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:love14/Client/ClientScreen.dart';
import 'package:love14/Config/LoginScreen.dart';
import 'package:love14/Controllers/theme_controller.dart';
import 'package:love14/Router/routes.dart';
import 'package:love14/Views/RefreshWrapper.dart';
import 'package:love14/Views/RestartWidget.dart';
import 'package:love14/Views/connectivity_service.dart';
import 'package:love14/Views/offline_screen.dart';
import 'package:love14/Views/splash_screen.dart';
import 'package:love14/Widgets/PullToRefreshWrapper.dart';
import 'package:love14/admin/AdminScreen.dart';
import 'package:love14/controllers/poem_controller.dart';
import 'package:love14/env_loader.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
// ignore: undefined_prefixed_name
import 'dart:ui' as ui;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvLoader.loadEnv();

  bool hasConnection = await checkInternetConnection();

  if (hasConnection) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: EnvLoader.get('API_KEY')!,
        authDomain: EnvLoader.get('AUTH_DOMAIN')!,
        databaseURL: EnvLoader.get('DATABASE_URL')!,
        projectId: EnvLoader.get('PROJECT_ID')!,
        storageBucket: EnvLoader.get('STORAGE_BUCKET')!,
        messagingSenderId: EnvLoader.get('MESSAGING_SENDER_ID')!,
        appId: EnvLoader.get('APP_ID')!,
        measurementId: EnvLoader.get('MEASUREMENT_ID')!,
      ),
    );

    if (!kIsWeb) {
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
  }

  final pref = await SharedPreferences.getInstance();
  final seenOnboarding = pref.getBool('seenOnboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => PoemController()),
      ],
      child: RestartWidget(
        child: MyApp(seenOnboarding: seenOnboarding, isOnline: hasConnection),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final bool isOnline;

  const MyApp({super.key, this.seenOnboarding = false, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });
    return MaterialApp(
      title: 'Flores Amarillas',
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
      themeMode: themeController.themeMode,
      home: Stack(
        children: [
          RefreshWrapper(isOnline: isOnline, seenOnboarding: seenOnboarding),
          if (kIsWeb) AutoPlayAudioWidget(), // Solo web
        ],
      ),
      debugShowCheckedModeBanner: false,
      routes: routes,
    );
  }
}

class AutoPlayAudioWidget extends StatelessWidget {
  const AutoPlayAudioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Registrar el elemento HTML solo una vez
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('audio-element', (int viewId) {
      final audio = html.AudioElement()
        ..src =
            EnvLoader.get('AUDIO') ??
            'https://raw.githubusercontent.com/18-anth/Love14/proyecto/assets/floresamarillas.mpeg'
        ..autoplay = true
        ..loop = true
        ..controls = false
        ..style.width = '0'
        ..style.height = '0'
        ..style.border = 'none';
      return audio;
    });

    return const SizedBox(
      width: 0,
      height: 0,
      child: HtmlElementView(viewType: 'audio-element'),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return FutureBuilder<DatabaseEvent>(
        future: FirebaseDatabase.instance
            .ref()
            .child('Control/')
            .child(user.uid)
            .once(),
        builder: (context, roleSnapshot) {
          if (roleSnapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(seenOnboarding: true);
          }

          if (roleSnapshot.hasError) {
            return const OfflineScreen();
          }

          if (!roleSnapshot.hasData ||
              roleSnapshot.data!.snapshot.value == null) {
            return const LoginScreen();
          }

          var userData =
              roleSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          String role = userData['role'] ?? '';

          if (role == 'Client') {
            return const PullToRefreshWrapper(child: ClientScreen());
          } else if (role == 'Admin') {
            return const PullToRefreshWrapper(child: AdminScreen());
          } else {
            return const Center(
              child: Text(
                'Rol no reconocido.',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            );
          }
        },
      );
    } else {
      return const LoginScreen();
    }
  }
}
