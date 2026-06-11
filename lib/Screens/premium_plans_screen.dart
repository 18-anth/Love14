import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:love14/Controllers/surprise_controller.dart';
import 'package:love14/Utils/app_colors.dart';
import 'package:love14/Widgets/romantic_button.dart';

class PremiumPlansScreen extends StatelessWidget {
  const PremiumPlansScreen({super.key, required String userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planes Premium'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
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
              child: Column(
                children: [
                  const Text(
                    '✨ Lleva tus sorpresas al siguiente nivel',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Con Premium tienes acceso a todas las funciones sin límites',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Plans comparison
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildPlanCard(
                    title: 'Gratis',
                    price: '\$0',
                    period: 'Siempre',
                    features: const [
                      'Hasta 1 sorpresa publicada por mes',
                      'Hasta 1 foto por sorpresa',
                      'Durabilidad: 7 días',
                      'Compartir básico',
                      'Poemas incluidos',
                    ],
                    isPremium: false,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildPlanCard(
                    title: 'Premium',
                    price: '\$4.99',
                    period: 'por mes',
                    features: const [
                      'Sorpresas ilimitadas',
                      'Hasta 20 fotos por sorpresa',
                      'Videos en HD',
                      'Música personalizada',
                      'Cartas de IA románticas',
                      'Durabilidad: 30 días',
                      'QR para compartir',
                      'Análisis detallados',
                      'Sin anuncios',
                      'Soporte prioritario',
                    ],
                    isPremium: true,
                    onTap: () {
                      _showPurchaseDialog(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preguntas frecuentes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFAQItem(
                    question: '¿Puedo cambiar de plan cuando quiera?',
                    answer:
                        'Sí, puedes cambiar o cancelar tu suscripción en cualquier momento desde la configuración de tu cuenta.',
                  ),
                  const SizedBox(height: 12),
                  _buildFAQItem(
                    question: '¿Mi información es segura?',
                    answer:
                        'Utilizamos encriptación de nivel militar para proteger tus sorpresas y datos personales.',
                  ),
                  const SizedBox(height: 12),
                  _buildFAQItem(
                    question: '¿Hay prueba gratuita?',
                    answer:
                        'Sí, tienes 7 días de prueba gratis del plan Premium. No se requiere tarjeta de crédito.',
                  ),
                  const SizedBox(height: 12),
                  _buildFAQItem(
                    question: '¿Qué pasa cuando se vence una sorpresa?',
                    answer:
                        'Las sorpresas gratuitas expiran después de 7 días. Las Premium duran 30 días. Puedes archivarlas antes de que expiren.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static Widget _buildPlanCard({
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required bool isPremium,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isPremium ? AppColors.primaryPink : Colors.grey[300]!,
          width: isPremium ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        color: isPremium ? AppColors.lightBackground : Colors.white,
        boxShadow: isPremium
            ? [
                BoxShadow(
                  color: AppColors.primaryPink.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: price,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color:
                                isPremium ? AppColors.primaryPink : Colors.grey,
                          ),
                        ),
                        TextSpan(
                          text: ' $period',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isPremium)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryYellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '⭐ Popular',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: isPremium
                              ? AppColors.primaryPink
                              : Colors.grey[400],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.darkText,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: isPremium
                ? ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPink,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Obtener Premium',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: AppColors.primaryPink),
                    ),
                    child: const Text('Actualmente activo'),
                  ),
          ),
        ],
      ),
    );
  }

  static Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  static void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Actualizar a Premium'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Disfruta de:'),
            SizedBox(height: 12),
            Text('✨ Sorpresas ilimitadas'),
            Text('📸 20 fotos por sorpresa'),
            Text('🎬 Videos en HD'),
            Text('🎵 Música personalizada'),
            Text('💌 Cartas de IA románticas'),
            SizedBox(height: 12),
            Text('Primer mes: \$0.99'),
            Text('Después: \$4.99/mes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<SurpriseController>().upgradeToPremium();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Bienvenido a Premium! 🎉'),
                  backgroundColor: AppColors.primaryPink,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryPink,
            ),
            child: const Text('Obtener Premium'),
          ),
        ],
      ),
    );
  }
}
