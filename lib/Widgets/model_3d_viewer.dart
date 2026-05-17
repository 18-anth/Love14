import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../Utils/app_colors.dart';

/// Widget reutilizable para renderizar modelos 3D
/// Funciona tanto en Web (ModelViewer) como en plataformas nativas (Flutter3DViewer)
class Model3DViewer extends StatefulWidget {
  final String modelUrl;
  final String altText;
  final bool autoRotate;
  final bool cameraControls;
  final Color? backgroundColor;
  final Color? progressBarColor;
  final double height;
  final double? width;
  final bool autoPlay;

  const Model3DViewer({
    super.key,
    required this.modelUrl,
    this.altText = 'Modelo 3D',
    this.autoRotate = true,
    this.cameraControls = true,
    this.backgroundColor,
    this.progressBarColor,
    this.height = 400,
    this.width,
    this.autoPlay = true,
  });

  @override
  State<Model3DViewer> createState() => _Model3DViewerState();
}

class _Model3DViewerState extends State<Model3DViewer> {
  final Flutter3DController _controller = Flutter3DController();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    debugPrint('🌸 [Model3DViewer] Inicializando — Web: $kIsWeb');
    debugPrint('🌸 [Model3DViewer] URL: ${widget.modelUrl}');
    
    if (!kIsWeb) {
      _controller.onModelLoaded.addListener(_onModelLoadedListener);
    }
  }

  void _onModelLoadedListener() {
    debugPrint(
      '🔔 [Model3DViewer] Modelo cargado: ${_controller.onModelLoaded.value}',
    );
    if (mounted && _controller.onModelLoaded.value) {
      setState(() {
        _isLoading = false;
      });
      if (widget.autoPlay) {
        _controller.playAnimation();
      }
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _controller.onModelLoaded.removeListener(_onModelLoadedListener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Modelo 3D
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: kIsWeb ? _buildWebViewer() : _buildNativeViewer(),
          ),
          
          // Indicador de carga
          if (_isLoading && !kIsWeb)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.lightBackground.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: widget.progressBarColor ?? AppColors.goldenHour,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Cargando modelo 3D...',
                      style: TextStyle(
                        color: AppColors.deepGreen,
                        fontFamily: 'Playfair',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Mensaje de error
          if (_error != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Error al cargar el modelo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Playfair',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _error!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebViewer() {
    return ModelViewer(
      src: widget.modelUrl,
      alt: widget.altText,
      autoRotate: widget.autoRotate,
      cameraControls: widget.cameraControls,
      backgroundColor: widget.backgroundColor ?? const Color.fromARGB(0, 0, 0, 0),
      loading: Loading.eager,
      ar: true,
      arModes: const ['scene-viewer', 'webxr', 'quick-look'],
      autoPlay: widget.autoPlay,
    );
  }

  Widget _buildNativeViewer() {
    return Flutter3DViewer(
      src: widget.modelUrl,
      controller: _controller,
      activeGestureInterceptor: true,
      progressBarColor: widget.progressBarColor ?? AppColors.goldenHour,
      enableTouch: widget.cameraControls,
      onProgress: (double progressValue) {
        debugPrint(
          '📦 [Model3DViewer] Progreso: ${(progressValue * 100).toStringAsFixed(0)}%',
        );
      },
      onLoad: (String modelAddress) {
        debugPrint('✅ [Model3DViewer] Modelo cargado: $modelAddress');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = null;
          });
        }
      },
      onError: (String error) {
        debugPrint('❌ [Model3DViewer] Error: $error');
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = error;
          });
        }
      },
    );
  }
}
