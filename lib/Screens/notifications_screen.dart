// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:love14/utils/app_styles.dart';
import 'package:love14/utils/app_colors.dart';
import 'package:video_player/video_player.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          'Nuestra Historia de Amor',
          style: AppStyles.titleStyle(
            context,
          ).copyWith(color: AppColors.deepGreen, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 5,
        shadowColor: AppColors.warmBrown.withOpacity(0.3),
      ),
      body: Container(
        margin: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.local_florist,
                size: 60,
                color: AppColors.warmBrown,
              ),
              Text(
                '💛 Anthony & Valeska 💛',
                style: AppStyles.titleStyle(
                  context,
                ).copyWith(fontSize: 26, color: AppColors.deepGreen),
              ),
              const SizedBox(height: 20),
              _buildLoveTimeline(),
              const SizedBox(height: 30),
              _buildLoveStoryText(context),
              const SizedBox(height: 30),
              Text(
                'Eres mi flor más hermosa,\nmi girasol eterno.',
                textAlign: TextAlign.center,
                style: AppStyles.poemContentStyle(context).copyWith(
                  color: AppColors.warmBrown,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.eco_rounded,
                color: AppColors.deepGreen,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoveTimeline() {
    return Card(
      color: AppColors.cream,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: AppColors.warmBrown.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTimelineItem('📅 14 de Febrero 2024', 'Nuestro primer beso'),
            _buildTimelineItem('🌟 25 de Abril 2024', 'Viaje inolvidable'),
            _buildTimelineItem(
              '🎉 12 de Julio 2024',
              'Conocí cada parte de tú ser',
            ),
            _buildTimelineItem('💍 1 de Octubre 2024', 'Promesa de futuro'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String date, String event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(Icons.star_rounded, color: AppColors.goldenHour, size: 24),
          const SizedBox(width: 10),
          Text(
            date,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.warmBrown,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              event,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.darkText,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoveStoryText(BuildContext context) {
    final paragraphs = [
      'La conocí hace ya mucho tiempo… La primera vez que la vi fue desde una moto...',
      'Años después, el destino la trajo al barrio donde yo vivía...',
      'El tiempo pasó y sufrí un accidente que marcó mi vida...',
      'Comenzamos a salir, a conocernos sin prisa pero con intensidad...',
      'La seguía a cada evento, a cada baile, solo por verla...',
      'Y llegó aquel 14 de febrero del 2024...',
      'Ese día, ella me sorprendió: me dijo que quería ser mi novia...',
      'Desde entonces vivimos momentos inolvidables...',
      'Tuvimos cenas románticas con alitas BBQ...',
      'Fuimos a la Lajilla, nos tomamos fotos, reímos...',
      'Recuerdo la vez que fuimos al Templete después de su evento...',
      'Cuando su padre la trató mal...',
      'Nunca olvidaré aquella vez que fuimos a dejar el cupo...',
      '¿Recuerdas cuando íbamos donde mi abuelita?...',
      'No soy perfecto, amor… pero cada día intento ser el mejor hombre para ti...',
      'Eres lo mejor que me ha pasado...',
      'Valeska… Te amo con cada parte de mi ser...',
    ];

    final videos = {
      2: 'https://storage.googleapis.com/love14flower/detalleamor.mp4',
      5: 'https://storage.googleapis.com/love14flower/feria.mp4',
      8: 'https://storage.googleapis.com/love14flower/moto.mp4',
      11: 'https://storage.googleapis.com/love14flower/reinado.mp4',
      13: 'https://storage.googleapis.com/love14flower/templete.mp4',
    };

    List<Widget> children = [];
    for (int i = 0; i < paragraphs.length; i++) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Text(
            paragraphs[i],
            textAlign: TextAlign.justify,
            style: AppStyles.poemContentStyle(context),
          ),
        ),
      );

      if (videos.containsKey(i)) {
        children.add(const SizedBox(height: 20));
        children.add(NetworkVideoWidget(videoUrl: videos[i]!));
        children.add(const SizedBox(height: 20));
      }
    }

    return Column(children: children);
  }
}

class NetworkVideoWidget extends StatefulWidget {
  final String videoUrl;

  const NetworkVideoWidget({super.key, required this.videoUrl});

  @override
  State<NetworkVideoWidget> createState() => _NetworkVideoWidgetState();
}

class _NetworkVideoWidgetState extends State<NetworkVideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.network(widget.videoUrl);

    try {
      await _controller.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      _controller.setLooping(true);

      // En web, algunos navegadores bloquean autoplay con sonido.
      // Por eso, ponemos el volumen en 0 y luego damos play.
      if (kIsWeb) {
        _controller.setVolume(0.0);
      }

      _controller.play();
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: const Text(
          'No se pudo cargar el video ❤️',
          style: TextStyle(color: AppColors.warmBrown),
        ),
      );
    }

    return _isInitialized
        ? Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: AppColors.warmBrown.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        )
        : Container(
          height: 200,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(color: AppColors.warmBrown),
        );
  }
}
