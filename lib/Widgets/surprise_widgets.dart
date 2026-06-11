import 'package:flutter/material.dart';
import 'package:love14/models/surprise_model.dart';

// ===== SECTION HEADER =====
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.pink.shade600,
      ),
    );
  }
}

// ===== FLOWER SELECTOR =====
class FlowerSelector extends StatelessWidget {
  final List<String> selectedFlowers;
  final Function(List<String>) onFlowersChanged;

  const FlowerSelector({
    Key? key,
    required this.selectedFlowers,
    required this.onFlowersChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const flowers = ['rose', 'tulip', 'sunflower', 'daisy', 'lily', 'orchid'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: flowers.map((flower) {
            final isSelected = selectedFlowers.contains(flower);
            return GestureDetector(
              onTap: () {
                if (isSelected) {
                  onFlowersChanged(
                    selectedFlowers.where((f) => f != flower).toList(),
                  );
                } else {
                  onFlowersChanged([...selectedFlowers, flower]);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.pink.shade300
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.pink.shade600
                        : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  _getFlowerLabel(flower),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Text(
          '${selectedFlowers.length} flor(es) seleccionada(s)',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  String _getFlowerLabel(String flower) {
    const labels = {
      'rose': '🌹 Rosa',
      'tulip': '🌷 Tulipán',
      'sunflower': '🌻 Girasol',
      'daisy': '🌼 Margarita',
      'lily': '🪷 Lirio',
      'orchid': '🌸 Orquídea',
    };
    return labels[flower] ?? flower;
  }
}

// ===== PREMIUM FEATURE BUTTON =====
class PremiumFeatureButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const PremiumFeatureButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.edit, size: 16, color: color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

// ===== PLAN INFO BOX =====
class PlanInfoBox extends StatelessWidget {
  const PlanInfoBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.card_giftcard, color: Colors.purple.shade600),
              const SizedBox(width: 8),
              Text(
                'Plan de Sorpresa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.purple.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _featureRow('Enlace público', true, Colors.green),
          const SizedBox(height: 12),
          _featureRow('Música personalizada', false, Colors.blue),
          const SizedBox(height: 12),
          _featureRow('Múltiples flores', false, Colors.blue),
          const SizedBox(height: 12),
          _featureRow('Fotos', false, Colors.blue),
          const SizedBox(height: 12),
          _featureRow('Videos', false, Colors.blue),
          const SizedBox(height: 12),
          _featureRow('Carta IA', false, Colors.blue),
          const SizedBox(height: 12),
          _featureRow('Código QR personalizado', false, Colors.blue),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, size: 16, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Mejora a Premium por \$${SurpriseFeatures.premiumPrice}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureRow(String label, bool available, Color color) {
    return Row(
      children: [
        Icon(
          available ? Icons.check_circle : Icons.lock,
          size: 16,
          color: available ? Colors.green : color.withOpacity(0.5),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: available ? Colors.black : Colors.grey,
            fontWeight: available ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ===== SURPRISE CARD (for listing) =====
class SurpriseCard extends StatelessWidget {
  final SurpriseModel surprise;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onPublish;

  const SurpriseCard({
    Key? key,
    required this.surprise,
    required this.onTap,
    this.onDelete,
    this.onPublish,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    surprise.isExpired();
    final daysLeft = surprise.daysUntilSpecialDate();

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Para: ${surprise.recipientName}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'De: ${surprise.creatorName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(surprise.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusLabel(surprise.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.pink,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            daysLeft >= 0 ? '$daysLeft días' : 'Vencida',
                            style: TextStyle(
                              fontSize: 12,
                              color: daysLeft < 0 ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (surprise.viewCount > 0)
                        Row(
                          children: [
                            const Icon(Icons.visibility, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${surprise.viewCount} vistas',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (surprise.status == SurpriseStatus.draft &&
                          onPublish != null)
                        IconButton(
                          icon: const Icon(Icons.publish),
                          color: Colors.green,
                          tooltip: 'Publicar',
                          onPressed: onPublish,
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          tooltip: 'Eliminar',
                          onPressed: onDelete,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(SurpriseStatus status) {
    switch (status) {
      case SurpriseStatus.draft:
        return Colors.grey;
      case SurpriseStatus.published:
        return Colors.green;
      case SurpriseStatus.viewed:
        return Colors.blue;
      case SurpriseStatus.expired:
        return Colors.red;
    }
  }

  String _getStatusLabel(SurpriseStatus status) {
    switch (status) {
      case SurpriseStatus.draft:
        return 'Borrador';
      case SurpriseStatus.published:
        return 'Publicada';
      case SurpriseStatus.viewed:
        return 'Vista';
      case SurpriseStatus.expired:
        return 'Vencida';
    }
  }
}

// ===== EMPTY STATE =====
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade300,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ===== PREMIUM BADGE =====
class PremiumBadge extends StatelessWidget {
  final bool isPremium;

  const PremiumBadge({Key? key, required this.isPremium}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isPremium) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 12, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'Premium',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
