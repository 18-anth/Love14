import 'package:flutter/material.dart';
import '../Widgets/model_3d_viewer.dart';
import '../Widgets/robot_3d_model.dart';
import '../Utils/app_colors.dart';

/// Pantalla de ejemplo para demostrar el uso de modelos 3D
class Model3DExampleScreen extends StatelessWidget {
  const Model3DExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text(
          'Modelos 3D',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontWeight: FontWeight.bold,
            color: AppColors.lightText,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.goldenHour,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              'Ejemplos de Modelos 3D',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.deepGreen,
                fontFamily: 'Playfair',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Interactúa con los modelos usando gestos táctiles o el ratón',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.warmBrown,
                fontFamily: 'Playfair',
              ),
            ),
            const SizedBox(height: 30),

            // Robot 3D - Usando el widget original
            _buildModelCard(
              title: 'Robot Futurista',
              description: 'Modelo del repositorio CV_Anth',
              icon: Icons.android,
              child: const RobotModel(),
            ),

            const SizedBox(height: 30),

            // Rosa Amarilla 3D - Usando el widget genérico
            _buildModelCard(
              title: 'Rosa Amarilla 3D',
              description: 'Modelo de flor rosa (ejemplo)',
              icon: Icons.local_florist,
              child: const Model3DViewer(
                modelUrl:
                    'https://raw.githubusercontent.com/18-anth/CV_Anth/proyecto/assets/svg/ModelBlender_robot_futurista.glb',
                altText: 'Rosa Amarilla 3D',
                autoRotate: true,
                cameraControls: true,
                height: 400,
                progressBarColor: AppColors.goldenHour,
              ),
            ),

            const SizedBox(height: 30),

            // Información de uso
            _buildInfoCard(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModelCard({
    required String title,
    required String description,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmBrown.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.goldenHour.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.warmBrown, size: 28),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepGreen,
                          fontFamily: 'Playfair',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.warmBrown.withOpacity(0.7),
                          fontFamily: 'Playfair',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Modelo 3D
          child,

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldenHour.withOpacity(0.2),
            AppColors.warmBrown.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.goldenHour.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.warmBrown, size: 28),
              const SizedBox(width: 10),
              const Text(
                'Cómo usar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepGreen,
                  fontFamily: 'Playfair',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildInfoItem(
            Icons.touch_app,
            'Toca y arrastra para rotar el modelo',
          ),
          _buildInfoItem(Icons.zoom_in, 'Pellizca para hacer zoom'),
          _buildInfoItem(
            Icons.rotate_right,
            'Los modelos rotan automáticamente',
          ),
          _buildInfoItem(
            Icons.cloud_download,
            'Funciona en Web y aplicaciones nativas',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.warmBrown, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.deepGreen,
                fontFamily: 'Playfair',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
