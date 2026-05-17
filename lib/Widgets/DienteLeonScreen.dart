// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../env_loader.dart';

class DienteDeLeonScreen extends StatefulWidget {
  const DienteDeLeonScreen({super.key});

  @override
  _DienteDeLeonScreenState createState() => _DienteDeLeonScreenState();
}

class _DienteDeLeonScreenState extends State<DienteDeLeonScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _caracteristicas = [
    "Como un diente de león al viento, llevas esperanza dondequiera que vas.",
    "Tu ternura se esparce como sus semillas: silenciosa, suave y transformadora.",
    "Eres belleza en lo sencillo, luz en lo cotidiano.",
    "Aunque parezcas frágil, resistes más de lo que imaginas.",
    "Cada deseo que soplo, siempre termina llevándome a ti.",
    "Así como el diente de león simboliza los sueños, tú eres el más hermoso de los míos.",
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
                            EnvLoader.get('DIENTELEON') ??
                            'https://raw.githubusercontent.com/18-anth/Love14/Main/assets/svg/diente_de_leon.glb',
                        alt: "Un diente de león 3D",
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
                          EnvLoader.get('DIENTELEON') ??
                          'https://raw.githubusercontent.com/18-anth/Love14/proyecto/assets/svg/diente_de_leon.glb',
                      alt: "Un diente de león 3D",
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
          Colors.yellow.withOpacity(0.4),
          Colors.orangeAccent.withOpacity(0.2),
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
            color: Colors.yellow.shade100,
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
    return 22;
  }

  String get _poema => '''
D e todas las flores, tú eres la que más inspira.
I luminada y ligera, como un diente de león al viento.
E res un deseo que no necesita pedirse, porque ya se cumple con tu presencia.
N ada en ti es ordinario; todo en ti es magia simple.
T u sonrisa es mi primavera.
E res la libertad que florece en el campo de mi corazón.

D onde hay un soplo, hay esperanza. Donde estás tú, hay amor.
E n cada pensamiento, vuelas sin que te llame.

L os sueños más dulces tienen tu aroma.
E res etérea y persistente, como los recuerdos hermosos.
Ó jalo pudiera soplarte al viento... pero prefiero que te quedes aquí conmigo.
N unca dejaré de admirar lo maravillosamente especial que eres. 🌼
''';
}
