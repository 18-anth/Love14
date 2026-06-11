import 'package:flutter/material.dart';
import 'package:love14/models/flower_model.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:love14/providers/surprise_provider.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:love14/Widgets/surprise_widgets.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';

class SurpriseViewScreen extends StatefulWidget {
  final String surpriseId;
  final bool isPublicView;

  const SurpriseViewScreen({
    super.key,
    required this.surpriseId,
    this.isPublicView = true,
  });

  @override
  State<SurpriseViewScreen> createState() => _SurpriseViewScreenState();
}

class _SurpriseViewScreenState extends State<SurpriseViewScreen> {
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  int _currentPhotoIndex = 0;
  bool _showLetter = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SurpriseProvider>().loadSurprise(widget.surpriseId);
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  void _initializeMedia(Surprise surprise) {
    // Initialize video player if video exists
    if (surprise.videoUrl != null && _videoController == null) {
      _videoController = VideoPlayerController.network(surprise.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
    }

    // Initialize audio player if music exists
    if (surprise.musicUrl != null && _audioPlayer == null) {
      _audioPlayer = AudioPlayer();
      _audioPlayer!.setUrl(surprise.musicUrl!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorpresa'),
        backgroundColor: Colors.pink.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareSurprise(context),
          ),
        ],
      ),
      body: Consumer<SurpriseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.currentSurprise == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Sorpresa no encontrada'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Atrás'),
                  ),
                ],
              ),
            );
          }

          final surprise = provider.currentSurprise!;
          _initializeMedia(surprise);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Header with flower
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade300, Colors.pink.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        surprise.flower.type.emoji,
                        style: const TextStyle(fontSize: 96),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        surprise.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'De: ${surprise.creatorName} Para: ${surprise.recipientName}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                surprise.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Photos Gallery
                      if (surprise.photoUrls.isNotEmpty) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Galería de Fotos',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    surprise.photoUrls[_currentPhotoIndex],
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 300,
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.image),
                                      );
                                    },
                                  ),
                                ),
                                if (surprise.photoUrls.length > 1) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: _currentPhotoIndex > 0
                                            ? () {
                                                setState(
                                                  () => _currentPhotoIndex--,
                                                );
                                              }
                                            : null,
                                      ),
                                      Text(
                                        '${_currentPhotoIndex + 1}/${surprise.photoUrls.length}',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward),
                                        onPressed:
                                            _currentPhotoIndex <
                                                surprise.photoUrls.length - 1
                                            ? () {
                                                setState(
                                                  () => _currentPhotoIndex++,
                                                );
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Video Player
                      if (surprise.videoUrl != null) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Video',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (_videoController != null &&
                                    _videoController!.value.isInitialized)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: AspectRatio(
                                      aspectRatio:
                                          _videoController!.value.aspectRatio,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          VideoPlayer(_videoController!),
                                          if (!_videoController!
                                              .value
                                              .isPlaying)
                                            IconButton(
                                              icon: const Icon(
                                                Icons.play_circle,
                                                size: 64,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _videoController!.play();
                                                });
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    height: 200,
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Music Player
                      if (surprise.musicUrl != null) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Música',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    StreamBuilder<PlayerState>(
                                      stream: _audioPlayer?.playerStateStream,
                                      builder: (context, snapshot) {
                                        final playerState = snapshot.data;
                                        final playing = playerState?.playing;

                                        return IconButton(
                                          icon: Icon(
                                            playing == true
                                                ? Icons.pause_circle
                                                : Icons.play_circle,
                                            size: 48,
                                            color: Colors.pink,
                                          ),
                                          onPressed: playing == true
                                              ? _audioPlayer?.pause
                                              : _audioPlayer?.play,
                                        );
                                      },
                                    ),
                                    Expanded(
                                      child: StreamBuilder<Duration?>(
                                        stream: _audioPlayer?.positionStream,
                                        builder: (context, snapshot) {
                                          final duration =
                                              _audioPlayer?.duration ??
                                              Duration.zero;
                                          final position =
                                              snapshot.data ?? Duration.zero;

                                          return Column(
                                            children: [
                                              Slider(
                                                min: 0,
                                                max: duration.inMilliseconds
                                                    .toDouble(),
                                                value: position.inMilliseconds
                                                    .toDouble(),
                                                onChanged: (value) {
                                                  _audioPlayer?.seek(
                                                    Duration(
                                                      milliseconds: value
                                                          .toInt(),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    _formatDuration(position),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  Text(
                                                    _formatDuration(duration),
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // AI Letter
                      if (surprise.aiLetter != null) ...[
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '💌 Carta Romántica',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        _showLetter
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                      ),
                                      onPressed: () {
                                        setState(
                                          () => _showLetter = !_showLetter,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                if (_showLetter) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.pink.shade50,
                                      border: Border.all(
                                        color: Colors.pink.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      surprise.aiLetter!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.8,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Statistics
                      if (!widget.isPublicView)
                        SurpriseStatsCard(surprise: surprise),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _shareSurprise(BuildContext context) {
    final surprise = context.read<SurpriseProvider>().currentSurprise;
    if (surprise != null) {
      Share.share(
        'Mira esta sorpresa especial: ${surprise.publicUrl}',
        subject: 'Sorpresa: ${surprise.title}',
      );
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
