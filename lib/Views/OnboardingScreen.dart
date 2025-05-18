// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _saveOnboardingSeen();
  }

  Future<void> _saveOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingPage(
        title: "Hola, mi flor hermosa 🌼",
        description:
            "Esta app está hecha con todo mi amor, para que recuerdes lo especial que eres para mí.",
        icon: MdiIcons.flower,
      ),
      _OnboardingPage(
        title: "Poemas y Recuerdos 💌",
        description:
            "Lee palabras que salen del alma y revive nuestros momentos inolvidables.",
        icon: MdiIcons.bookHeart,
      ),
      _OnboardingPage(
        title: "Flores para Ti 🌻",
        description:
            "Mira animaciones de flores amarillas, como las que te gustan, tan bellas como tú.",
        icon: MdiIcons.flowerTulipOutline,
      ),
      _OnboardingPage(
        title: "Favoritos y Memorias ✨",
        description:
            "Guarda lo que más te gusta y revive cada historia con solo un toque.",
        icon: Icons.favorite,
      ),
      _OnboardingPage(
        title: "Comencemos este viaje 💫",
        description:
            "Toca el botón y entra a este rincón hecho con cariño solo para ti.",
        icon: Icons.arrow_forward_rounded,
      ),
    ];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color:
            _currentIndex.isEven
                ? const Color(0xfffff8e7)
                : const Color(0xffffe0b2),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (_, index) => pages[index],
            ),
            Positioned(
              top: 50,
              right: 20,
              child:
                  _currentIndex < pages.length - 1
                      ? TextButton(
                        onPressed:
                            () => Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            ),
                        child: const Text(
                          "Saltar",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      )
                      : const SizedBox(),
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => _DotIndicator(isActive: _currentIndex == index),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child:
                    _currentIndex == pages.length - 1
                        ? Center(
                          child: ElevatedButton(
                            onPressed:
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xfff4a261),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                            ),
                            child: const Text(
                              "Comenzar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title, description;
  final IconData icon;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 100,
          color: const Color(0xffe76f51),
        ).animate().fadeIn().scale(),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ).animate().fadeIn(duration: const Duration(milliseconds: 800)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ).animate().fadeIn(duration: const Duration(milliseconds: 1000)),
        ),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isActive;
  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: isActive ? 16 : 12,
      height: isActive ? 16 : 12,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xffe76f51) : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
