// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../env_loader.dart';

class TulipanScreen extends StatefulWidget {
  const TulipanScreen({super.key});

  @override
  _TulipanScreenState createState() => _TulipanScreenState();
}

class _TulipanScreenState extends State<TulipanScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _caracteristicas = [
    "Como un tulipán al amanecer, eres la promesa de un día hermoso.",
    "Delicada pero fuerte, así como tú enfrentas la vida.",
    "Los tulipanes florecen en primavera, tú floreces en cada momento que sonríes.",
    "Cada color de tulipán tiene un significado, pero tú los reúnes todos: amor, alegría, ternura.",
    "Así como el tulipán se abre con el sol, mi corazón se abre cuando estás cerca.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            EnvLoader.get('TULIPAN') ??
                            'https://raw.githubusercontent.com/18-anth/Love14/proyecto/assets/svg/tulipan.glb',
                        alt: "Un tulipán 3D",
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
                          constraints.maxHeight * 0.5,
                          constraints.maxWidth * 0.4,
                        ),
                        _buildLoveCards(context),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              Expanded(
                flex: 8,
                child: Center(
                  child: SizedBox(
                    height: constraints.maxHeight * 0.8,
                    child: ModelViewer(
                      src:
                          EnvLoader.get('TULIPAN') ??
                          'https://raw.githubusercontent.com/18-anth/Love14/Main/assets/svg/tulipan.glb',
                      alt: "Un tulipán 3D",
                      ar: true,
                      autoPlay: true,
                      autoRotate: true,
                      cameraControls: true,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPoemContainer(
                          context,
                          MediaQuery.of(context).size.height * 0.3,
                          MediaQuery.of(context).size.width * 0.9,
                        ),
                        const SizedBox(height: 20),
                        _buildLoveCards(context),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
T u dulzura florece como un tulipán en primavera.  
U n detalle tuyo puede cambiar mi día entero.  
L lenas de color mis pensamientos más grises.  
I luminada estás siempre, incluso en lo simple.  
P or eso, cuando pienso en belleza, pienso en ti.  
A marte es como admirar un tulipán: sereno, profundo, inevitable.  
N o hay jardín más perfecto que el que florece contigo. 🌷  
''';
}
