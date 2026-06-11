import 'package:flutter/material.dart';
import 'package:love14/Features/Surprises/Domain/models/freemium_model.dart';

class PremiumBadge extends StatelessWidget {
  final bool isPremium;
  final Size size;

  const PremiumBadge({
    super.key,
    required this.isPremium,
    this.size = const Size(30, 30),
  });

  @override
  Widget build(BuildContext context) {
    if (!isPremium) return const SizedBox.shrink();

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '★',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PlanFeatureItem extends StatelessWidget {
  final PlanFeature feature;
  final bool isAvailable;

  const PlanFeatureItem({
    super.key,
    required this.feature,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.grey.shade400,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          feature.displayName,
          style: TextStyle(
            fontSize: 14,
            color: isAvailable ? Colors.black87 : Colors.grey.shade500,
            decoration: isAvailable ? TextDecoration.none : TextDecoration.lineThrough,
          ),
        ),
      ],
    );
  }
}

class PricingCard extends StatelessWidget {
  final String planName;
  final double price;
  final String currency;
  final List<String> features;
  final VoidCallback onUpgrade;
  final bool isCurrentPlan;
  final String? discount;

  const PricingCard({
    super.key,
    required this.planName,
    required this.price,
    required this.currency,
    required this.features,
    required this.onUpgrade,
    this.isCurrentPlan = false,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isCurrentPlan ? 4 : 1,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isCurrentPlan
              ? Border.all(color: Colors.pink, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  planName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (discount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Ahorra $discount',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '\$$price',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '/$currency',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...features.map((feature) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check,
                      size: 20,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      feature,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCurrentPlan ? null : onUpgrade,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCurrentPlan ? Colors.grey : Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  isCurrentPlan ? 'Plan Actual' : 'Mejorar Ahora',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FreemiumLimitBanner extends StatelessWidget {
  final int current;
  final int limit;
  final String itemName;

  const FreemiumLimitBanner({
    super.key,
    required this.current,
    required this.limit,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    final isAtLimit = current >= limit;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAtLimit ? Colors.red.shade50 : Colors.blue.shade50,
        border: Border.all(
          color: isAtLimit ? Colors.red.shade300 : Colors.blue.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isAtLimit ? Icons.warning : Icons.info,
            color: isAtLimit ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isAtLimit
                  ? 'Límite alcanzado: $current/$limit $itemName'
                  : 'Usaste $current/$limit $itemName',
              style: TextStyle(
                fontSize: 12,
                color: isAtLimit ? Colors.red : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
