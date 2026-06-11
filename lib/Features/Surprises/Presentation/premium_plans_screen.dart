import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:love14/Features/Surprises/Providers/surprise_provider.dart';
import 'package:love14/Features/Surprises/Services/payment_service.dart';
import 'package:love14/Features/Surprises/Widgets/premium_widgets.dart';

class PremiumPlansScreen extends StatefulWidget {
  final String userId;

  const PremiumPlansScreen({
    super.key,
    required this.userId,
  });

  @override
  State<PremiumPlansScreen> createState() => _PremiumPlansScreenState();
}

class _PremiumPlansScreenState extends State<PremiumPlansScreen> {
  final PaymentService _paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    final plans = _paymentService.getPricingPlans();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planes Premium'),
        backgroundColor: Colors.pink.shade400,
        elevation: 0,
      ),
      body: Consumer<SurpriseProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
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
                      const Icon(Icons.star, size: 64, color: Colors.white),
                      const SizedBox(height: 16),
                      const Text(
                        'Desbloquea Funciones Premium',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Crea sorpresas ilimitadas con todas las características',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Plans
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Monthly Plan
                      PricingCard(
                        planName: plans['monthly']['name'],
                        price: plans['monthly']['price'],
                        currency: 'mes',
                        features: List<String>.from(
                          plans['monthly']['features'],
                        ),
                        onUpgrade: () =>
                            _processPurchase(context, provider, 'monthly', 1),
                        isCurrentPlan: provider.isPremium,
                      ),
                      const SizedBox(height: 16),

                      // Quarterly Plan (with discount)
                      PricingCard(
                        planName: plans['quarterly']['name'],
                        price: plans['quarterly']['price'],
                        currency: '3 meses',
                        discount: plans['quarterly']['discount'],
                        features: List<String>.from(
                          plans['quarterly']['features'],
                        ),
                        onUpgrade: () =>
                            _processPurchase(context, provider, 'quarterly', 3),
                        isCurrentPlan: provider.isPremium,
                      ),
                      const SizedBox(height: 16),

                      // Yearly Plan (best value)
                      PricingCard(
                        planName: plans['yearly']['name'],
                        price: plans['yearly']['price'],
                        currency: 'año',
                        discount: plans['yearly']['discount'],
                        features: List<String>.from(
                          plans['yearly']['features'],
                        ),
                        onUpgrade: () =>
                            _processPurchase(context, provider, 'yearly', 12),
                        isCurrentPlan: provider.isPremium,
                      ),
                    ],
                  ),
                ),

                // Features Comparison
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildFeaturesComparison(),
                ),

                // FAQ
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildFAQ(),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturesComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comparar Características',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _ComparisonRow(
              feature: 'Sorpresas ilimitadas',
              free: false,
              premium: true,
            ),
            _ComparisonRow(
              feature: 'Múltiples flores',
              free: false,
              premium: true,
            ),
            _ComparisonRow(
              feature: 'Fotos y Videos',
              free: false,
              premium: true,
            ),
            _ComparisonRow(
              feature: 'Música personalizada',
              free: false,
              premium: true,
            ),
            _ComparisonRow(
              feature: 'Cartas IA',
              free: false,
              premium: true,
            ),
            _ComparisonRow(
              feature: 'QR personalizado',
              free: false,
              premium: true,
            ),
            _ComparisonRow(
              feature: 'Analíticas avanzadas',
              free: false,
              premium: true,
            ),
            _ComparisonRow(
              feature: 'Soporte prioritario',
              free: false,
              premium: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preguntas Frecuentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _FAQItem(
              question: '¿Puedo cancelar en cualquier momento?',
              answer:
                  'Sí, tu suscripción se puede cancelar en cualquier momento. No hay cargos de cancelación.',
            ),
            _FAQItem(
              question: '¿Incluye período de prueba?',
              answer:
                  'Contacta a nuestro equipo de soporte para una prueba de 7 días.',
            ),
            _FAQItem(
              question: '¿Se renueva automáticamente?',
              answer:
                  'Sí, tu suscripción se renovará automáticamente. Puedes cancelar en cualquier momento.',
            ),
            _FAQItem(
              question: '¿Métodos de pago aceptados?',
              answer:
                  'Aceptamos todas las tarjetas de crédito y débito principales a través de Stripe.',
            ),
          ],
        ),
      ),
    );
  }

  void _processPurchase(
    BuildContext context,
    SurpriseProvider provider,
    String planType,
    int months,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Procesar Pago'),
        content: const Text(
          'Esta es una demostración. En producción, esto iniciará el proceso de pago con Stripe.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simulate payment success
              provider.upgradeToPremium(widget.userId);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('¡Upgrade exitoso!'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
            ),
            child: const Text('Confirmar Pago',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String feature;
  final bool free;
  final bool premium;

  const _ComparisonRow({
    required this.feature,
    required this.free,
    required this.premium,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(feature),
          ),
          SizedBox(
            width: 60,
            child: Center(
              child: Icon(
                free ? Icons.check_circle : Icons.cancel,
                color: free ? Colors.grey.shade400 : Colors.grey.shade400,
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Center(
              child: Icon(
                premium ? Icons.check_circle : Icons.cancel,
                color: premium ? Colors.green : Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(widget.answer),
        ),
      ],
    );
  }
}
