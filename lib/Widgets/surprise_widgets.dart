import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:love14/models/flower_model.dart';
import 'package:love14/models/surprise_model.dart';

class SurpriseCard extends StatelessWidget {
  final Surprise surprise;
  final VoidCallback onTap;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const SurpriseCard({
    super.key,
    required this.surprise,
    required this.onTap,
    this.onShare,
    this.onDelete, Future<void> Function()? onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                          surprise.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Para: ${surprise.recipientName}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      if (onShare != null)
                        PopupMenuItem(
                          onTap: onShare,
                          child: const Row(
                            children: [
                              Icon(Icons.share),
                              SizedBox(width: 8),
                              Text('Compartir'),
                            ],
                          ),
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          onTap: onDelete,
                          child: const Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Eliminar'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                surprise.flower.type.emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.visibility,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${surprise.getViewCount()}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(surprise.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SurpriseStatsCard extends StatelessWidget {
  final Surprise surprise;

  const SurpriseStatsCard({super.key, required this.surprise});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _StatRow(
              icon: Icons.visibility,
              label: 'Vistas',
              value: surprise.getViewCount().toString(),
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.share,
              label: 'Compartidas',
              value: surprise.getShareCount().toString(),
            ),
            const SizedBox(height: 12),
            _StatRow(
              icon: Icons.calendar_today,
              label: 'Creada el',
              value: DateFormat('dd MMM yyyy').format(surprise.createdAt),
            ),
            if (surprise.viewedAt != null) ...[
              const SizedBox(height: 12),
              _StatRow(
                icon: Icons.check_circle,
                label: 'Vista el',
                value: DateFormat('dd MMM yyyy').format(surprise.viewedAt!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.pink),
            const SizedBox(width: 12),
            Text(label),
          ],
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }
}

/// Empty state widget for empty lists
class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String actionLabel;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onAction,
    this.actionLabel = 'Crear',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          if (onAction != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
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
