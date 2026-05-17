// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../env_loader.dart';

class Flower3DScreen extends StatefulWidget {
  const Flower3DScreen({super.key});

  @override
  _Flower3DScreenState createState() => _Flower3DScreenState();
}

class _Flower3DScreenState extends State<Flower3DScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _caracteristicas = [
    "Siempre encuentras la forma de brillar, incluso en los días nublados.",
    "Tu calidez se siente como el sol en una mañana tranquila.",
    "Así como el girasol busca la luz, yo siempre te busco a ti.",
    "Eres belleza natural, sin pretensiones ni adornos innecesarios.",
    "Tu presencia alegra cualquier lugar, igual que un campo lleno de girasoles.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1), // color suave para girasol
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: SizedBox(
                      height: constraints.maxHeight * 0.8,
                      child: ModelViewer(
                        src:
                            EnvLoader.get('FLOWER') ??
                            'https://raw.githubusercontent.com/18-anth/Love14/Main/assets/svg/flower.glb',
                        alt: "Un girasol 3D",
                        ar: true,
                        autoPlay: true,
                        autoRotate: true,
                        cameraControls: true,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildPoemContainer(
                          context,
                          constraints.maxHeight * 0.7,
                          constraints.maxWidth * 0.5,
                        ),
                        _buildLoveCards(context),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ModelViewer(
                    src:
                        EnvLoader.get('FLOWER') ??
                        'https://raw.githubusercontent.com/18-anth/Love14/proyecto/assets/svg/flower.glb',
                    alt: "Un girasol 3D",
                    ar: true,
                    autoPlay: true,
                    autoRotate: true,
                    cameraControls: true,
                  ),
                ),
                _buildPoemContainer(
                  context,
                  MediaQuery.of(context).size.height * 0.5,
                  MediaQuery.of(context).size.width * 0.9,
                ),
                _buildLoveCards(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPoemContainer(
    BuildContext context,
    double height,
    double width,
  ) {
    return GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: 30,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderGradient: LinearGradient(
        colors: [
          Colors.orangeAccent.withOpacity(0.5),
          Colors.deepOrange.withOpacity(0.2),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: SingleChildScrollView(
          child: AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                _poema,
                textStyle: GoogleFonts.dancingScript(
                  fontSize: _getTextSize(context),
                  color: const Color(0xff2D2D2D),
                  fontWeight: FontWeight.w500,
                ),
                speed: const Duration(milliseconds: 50),
              ),
            ],
            isRepeatingAnimation: false,
            displayFullTextOnTap: true,
          ),
        ),
      ),
    );
  }

  Widget _buildLoveCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _caracteristicas.map((mensaje) {
          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.amber.shade100,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                mensaje,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.brown.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  double _getTextSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return 32;
    if (width > 600) return 20;
    return 22; // Tamaño para móviles
  }

  String get _poema => '''
    G ᴜᴀʀᴅᴀ sɪᴇᴍᴘʀᴇ ʟᴀ ʟᴜᴢ ᴅᴇ ᴍɪ ᴠɪᴅᴀ.
    I ɴsᴘɪʀᴀs ᴍɪ ᴀʟᴇɢʀíᴀ ᴄᴀᴅᴀ ᴅíᴀ.
    R ᴇsᴘʟᴀɴᴅᴇᴄᴇs ᴄᴏɴ ᴛᴜ ᴘʀᴏᴘɪᴏ ʙʀɪʟʟᴏ.
    A ᴄᴏᴍᴘᴀñᴀs ᴍɪs ᴅɪᴀs ᴄᴏɴ ᴄᴀʟɪᴅᴇᴢ
    S ɪᴇᴍᴘʀᴇ ʙᴜsᴄᴀɴᴅᴏ ᴛᴜ sᴏɴʀɪsᴀ.
    O ʀʙɪᴛᴀ ᴀʟʀᴇᴅᴇᴅᴏʀ ᴅᴇ ᴛᴜ ᴀᴍᴏʀ.
    L ʟᴇɴᴀs ᴍɪ ᴠɪᴅᴀ ᴅᴇ ᴄᴏʟᴏʀ ʏ ᴀʟᴇɢʀíᴀ.

    ᴘᴏʀ Qᴜᴇ ᴇʀᴇs ᴍɪ sᴏʟ, ᴍɪ ɢɪʀᴀsᴏʟ 🌻
''';
}
