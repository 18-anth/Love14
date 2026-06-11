import 'package:flutter/material.dart';
import 'package:love14/models/flower_model.dart';
import 'package:provider/provider.dart';
import 'package:love14/Controllers/surprise_controller.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:love14/Utils/app_colors.dart';
import 'package:love14/Widgets/model_3d_viewer.dart';
import 'package:love14/Widgets/poem_card.dart';
import 'package:love14/Widgets/romantic_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SurpriseViewScreen extends StatefulWidget {
  final String surpriseId;
  final bool isPublic;

  const SurpriseViewScreen({
    super.key,
    required this.surpriseId,
    this.isPublic = false,
  });

  @override
  State<SurpriseViewScreen> createState() => _SurpriseViewScreenState();
}

class _SurpriseViewScreenState extends State<SurpriseViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  VideoPlayerController? _videoController;
  bool _isLoadingVideo = false;
  bool _hasTrackedView = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _trackViewOnce();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  void _trackViewOnce() {
    if (!_hasTrackedView) {
      _hasTrackedView = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SurpriseController>().trackSurpriseView(widget.surpriseId);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _loadVideo(String videoUrl) async {
    try {
      setState(() {
        _isLoadingVideo = true;
      });

      _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {
            _isLoadingVideo = false;
          });
        });
    } catch (e) {
      debugPrint('Error loading video: $e');
      setState(() {
        _isLoadingVideo = false;
      });
    }
  }

  void _shareOnWhatsApp(String message, String link) {
    final text =
        '${message}\n\n🌹 Ver sorpresa: $link\n\n💕 Enviado desde Love14';
    Share.share(text, subject: 'Sorpresa especial para ti');
  }

  void _shareSurprise() {
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        builder: (context) => _buildShareOptions(),
      );
    }
  }

  void _showQRCode(Surprise surprise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBackground,
        title: const Text('Código QR'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryPink),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text('QR Code'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Escanea para ver la sorpresa',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: widget.isPublic
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
        actions: [
          if (!widget.isPublic)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Navigate to edit screen
              },
            ),
          if (!widget.isPublic)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // TODO: Show delete confirmation
              },
            ),
        ],
      ),
      body: FutureBuilder<Surprise?>(
        future: context.read<SurpriseController>().getSurpriseById(
          widget.surpriseId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPink,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.broken_image_outlined,
                    size: 64,
                    color: AppColors.primaryPink,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Sorpresa no encontrada',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'La sorpresa puede haber expirado o no existe',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          }

          final surprise = snapshot.data!;

          return SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeroSection(surprise, isMobile),
                  Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFromToSection(surprise),
                        const SizedBox(height: 24),
                        _buildTitleSection(surprise),
                        const SizedBox(height: 24),
                        if (surprise.specialDate != null)
                          _buildDateSection(surprise),
                        _buildFlowerSection(surprise),
                        const SizedBox(height: 24),
                        _buildPoemSection(surprise),
                        const SizedBox(height: 24),
                        if (surprise.photoUrls.isNotEmpty)
                          _buildPhotosSection(surprise),
                        if (surprise.videoUrl != null)
                          _buildVideoSection(surprise),
                        if (surprise.musicUrl != null)
                          _buildMusicSection(surprise),
                        if (surprise.customMessage != null &&
                            surprise.customMessage!.isNotEmpty)
                          _buildMessageSection(surprise),
                        if (surprise.aiLetter != null &&
                            surprise.aiLetter!.isNotEmpty)
                          _buildAILetterSection(surprise),
                        const SizedBox(height: 32),
                        _buildStatsSection(surprise),
                        const SizedBox(height: 24),
                        _buildQRSection(surprise),
                        const SizedBox(height: 24),
                        _buildActionButtons(surprise),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============ WIDGET BUILDERS ============

  Widget _buildHeroSection(Surprise surprise, bool isMobile) {
    return Container(
      height: isMobile ? 300 : 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryPink.withOpacity(0.3),
            AppColors.lightYellow.withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              surprise.flower.type.emoji,
              style: TextStyle(fontSize: isMobile ? 80 : 120),
            ),
            const SizedBox(height: 16),
            Text(
              surprise.flower.type.displayName,
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFromToSection(Surprise surprise) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryPink),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'De:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                surprise.creatorName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Icon(Icons.favorite, color: AppColors.primaryPink),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Para:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                surprise.recipientName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          surprise.title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        if (surprise.description.isNotEmpty)
          Text(
            surprise.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
      ],
    );
  }

  Widget _buildDateSection(Surprise surprise) {
    final date = surprise.specialDate;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightYellow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.goldenHour),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppColors.goldenHour),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Fecha especial',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.warmBrown,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${date.day} de ${_getMonthName(date.month)} de ${date.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warmBrown,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlowerSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'La Flor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryPink),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                surprise.flower.type.emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surprise.flower.type.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Color: ${surprise.flower.color}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPoemSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'El Poema',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryPink),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Poema seleccionado',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'El poema romántico se mostrará aquí',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPhotosSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fotos (${surprise.photoUrls.length})',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          children: surprise.photoUrls
              .map((url) => _buildPhotoTile(url))
              .toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPhotoTile(String photoUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              photoUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                ),
              ),
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vídeo 🎬',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          height: 300,
          child: _isLoadingVideo
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryPink,
                    ),
                  ),
                )
              : _videoController != null &&
                    _videoController!.value.isInitialized
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: VideoPlayer(_videoController!),
                )
              : GestureDetector(
                  onTap: () => _loadVideo(surprise.videoUrl!),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[800],
                    ),
                    child: const Icon(
                      Icons.play_circle_filled,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMusicSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Música 🎵',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryPink.withOpacity(0.2),
                AppColors.primaryYellow.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryPink),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.music_note,
                color: AppColors.primaryPink,
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Música romántica',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toca para reproducir',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryPink,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  onPressed: () {
                    // TODO: Play music
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMessageSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mensaje Personal 💌',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryPink, width: 2),
          ),
          child: Text(
            surprise.customMessage ?? '',
            style: const TextStyle(
              fontSize: 16,
              height: 1.8,
              fontStyle: FontStyle.italic,
              color: AppColors.darkText,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAILetterSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Carta Generada por IA ✨',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.lightYellow.withOpacity(0.5),
                AppColors.lightPink.withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryPink),
          ),
          child: Text(
            surprise.aiLetter ?? '',
            style: const TextStyle(
              fontSize: 15,
              height: 1.8,
              color: AppColors.darkText,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatsSection(Surprise surprise) {
    final viewCount = context.watch<SurpriseController>().getViewCount(
      widget.surpriseId,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryPink),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightBackground,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('👁️ Vistas', viewCount.toString()),
          const SizedBox(
            height: 40,
            child: VerticalDivider(color: AppColors.primaryPink),
          ),
          _buildStatItem(
            '❤️ Me gusta',
            (surprise.analytics?['likes'] ?? 0).toString(),
          ),
          const SizedBox(
            height: 40,
            child: VerticalDivider(color: AppColors.primaryPink),
          ),
          _buildStatItem(
            '📤 Compartidas',
            (surprise.analytics?['shares'] ?? 0).toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryPink,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildQRSection(Surprise surprise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comparte el Código QR',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryPink),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryPink),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('QR Code'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Escanea para ver esta sorpresa',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(Surprise surprise) {
    final isCreator =
        FirebaseAuth.instance.currentUser?.uid == surprise.creatorId;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showQRCode(surprise),
                icon: const Icon(Icons.qr_code),
                label: const Text('QR'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _shareSurprise,
                icon: const Icon(Icons.share),
                label: const Text('Compartir'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isCreator || !widget.isPublic)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (widget.isPublic) {
                  Navigator.pushNamed(context, '/surprise-history');
                } else {
                  context.read<SurpriseController>().publishSurprise(
                    widget.surpriseId,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
              ),
              child: Text(
                widget.isPublic ? 'Ver mis sorpresas' : 'Publicar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildShareOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Compartir sorpresa',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildShareOption(
            icon: '💬',
            title: 'WhatsApp',
            onTap: () {
              Navigator.pop(context);
              _shareOnWhatsApp(
                'Te tengo una sorpresa especial',
                context.read<SurpriseController>().currentSurprise?.publicUrl ??
                    '',
              );
            },
          ),
          const SizedBox(height: 12),
          _buildShareOption(
            icon: '✈️',
            title: 'Telegram',
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement Telegram share
            },
          ),
          const SizedBox(height: 12),
          _buildShareOption(
            icon: '📧',
            title: 'Email',
            onTap: () {
              Navigator.pop(context);
              // TODO: Implement Email share
            },
          ),
          const SizedBox(height: 12),
          _buildShareOption(
            icon: '🔗',
            title: 'Copiar enlace',
            onTap: () {
              Navigator.pop(context);
              // TODO: Copy to clipboard
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    return months[month - 1];
  }
}
