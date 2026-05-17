// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../env_loader.dart';

class Margarita3DScreen extends StatefulWidget {
  const Margarita3DScreen({super.key});

  @override
  _Margarita3DScreenState createState() => _Margarita3DScreenState();
}

class _Margarita3DScreenState extends State<Margarita3DScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Diseño horizontal para pantallas grandes
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
                            EnvLoader.get('MARGARITA') ??
                            'https://raw.githubusercontent.com/18-anth/Love14/proyecto/assets/svg/margarita.glb',
                        alt: "Una margarita 3D",
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
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPoemContainer(
                            context,
                            constraints.maxHeight * 0.5,
                            constraints.maxWidth * 0.4,
                          ),
                          const SizedBox(height: 20),
                          _buildCardsSection(
                            context,
                            constraints.maxWidth * 0.4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          // Diseño vertical para móviles y tablets
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: SizedBox(
                    height: constraints.maxHeight * 0.4,
                    child: ModelViewer(
                      src:
                          EnvLoader.get('MARGARITA') ??
                          'https://raw.githubusercontent.com/18-anth/Love14/proyecto/assets/svg/margarita.glb',
                      alt: "Una margarita 3D",
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildPoemContainer(
                          context,
                          constraints.maxHeight * 0.3,
                          constraints.maxWidth * 0.9,
                        ),
                        const SizedBox(height: 20),
                        _buildCardsSection(context, constraints.maxWidth * 0.9),
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
          Colors.white70.withOpacity(0.5),
          Colors.lightGreenAccent.withOpacity(0.2),
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

  double _getTextSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1000) return 32;
    if (width > 600) return 20;
    return 22;
  }

  Widget _buildCardsSection(BuildContext context, double width) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          _specialCard(
            title: "Eres como una margarita",
            content:
                "Pura, sencilla y llena de luz, tu esencia ilumina todo a tu alrededor, igual que esta flor que refleja la belleza en la simplicidad.",
          ),
          const SizedBox(height: 12),
          _specialCard(
            title: "Tu belleza es natural",
            content:
                "Como la margarita que florece con gracia, tú resplandeces sin esfuerzo, mostrando la autenticidad que te hace única y especial.",
          ),
          const SizedBox(height: 12),
          _specialCard(
            title: "Siempre das alegría",
            content:
                "Así como esta flor levanta el ánimo con su frescura, tú llenas mi vida de alegría, esperanza y amor en cada momento compartido.",
          ),
        ],
      ),
    );
  }

  Widget _specialCard({required String title, required String content}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.amber.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: Colors.grey[900],
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _poema => '''
M A R G A R I T A,  ʟᴀ ғʟᴏʀ ᴅᴇ ʟᴀ ɪɴᴏᴄᴇɴᴄɪᴀ,  
ᴛᴜ ʟᴜᴢ ᴅᴇsᴘᴇʀᴛᴀ ʜᴏʀᴀs ᴅᴇ ᴀᴍᴏʀ ʏ ᴘᴀᴢ.  
ᴄᴀᴅᴀ ᴘᴇᴛᴀʟᴏ ᴜɴ ᴀʙʀᴀᴢᴏ, ᴜɴ sᴜsᴜʀʀᴏ ᴅᴇ ᴛᴇ ɴɪᴇᴠᴏ,  
ɢᴜᴀʀᴅᴀ ᴇʟ sɪʟᴇɴᴄɪᴏ ᴅᴇ ʟᴀ ᴛɪᴇʀʀᴀ ᴛᴜ sᴀʙɪᴅᴜʀɪᴀ.

Qᴜᴇʀɪᴅᴀ,  ᴇʀᴇs ᴄᴏᴍᴏ ᴇsᴛᴀ ғʟᴏʀ,  ɴᴀᴛᴜʀᴀʟ ʏ ᴠɪᴠᴀ,  
ʟᴀ ᴍᴀʀɢᴀʀɪᴛᴀ ǫᴜᴇ ʟᴇ ᴅᴀ ʟᴀ ʟᴜᴢ ᴀ ᴍɪ ᴠɪᴅᴀ.  
Cᴀᴅᴀ ᴅíᴀ ʙʀɪʟʟᴀs,  ᴄᴏᴍᴏ ᴜɴ ᴛᴇsᴏʀ ᴍᴀʀᴀᴠɪʟʟᴏsᴏ,  
ᴍɪ ᴍᴀʀɢᴀʀɪᴛᴀ,  ᴛᴜ ᴀᴍᴏʀ ᴇs ᴍɪ ʟᴜᴢ,  ᴍɪ ᴄᴀᴍɪɴᴏ.
''';
}
