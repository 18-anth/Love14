import 'package:flutter/material.dart';
import 'package:love14/models/flower_model.dart';
import 'package:love14/models/surprise_model.dart';

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

/// Surprise card widget for displaying surprise summary
class SurpriseCard extends StatelessWidget {
  final Surprise surprise;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final VoidCallback? onPublish;
  final VoidCallback? onDelete;

  const SurpriseCard({
    super.key,
    required this.surprise,
    this.onTap,
    this.onShare,
    this.onPublish,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    surprise.flower.type.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 12),
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
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getStatusLabel(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onShare != null)
                    IconButton(
                      icon: const Icon(Icons.share, size: 20),
                      onPressed: onShare,
                      tooltip: 'Compartir',
                    ),
                  if (onPublish != null)
                    IconButton(
                      icon: const Icon(Icons.publish, size: 20),
                      onPressed: onPublish,
                      tooltip: 'Publicar',
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: onDelete,
                      tooltip: 'Eliminar',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusLabel() {
    return surprise.status.toString().split('.').last.toUpperCase();
  }

  Color _getStatusColor() {
    switch (surprise.status) {
      case SurpriseStatus.draft:
        return Colors.grey;
      case SurpriseStatus.published:
        return Colors.green;
      case SurpriseStatus.viewed:
        return Colors.blue;
      case SurpriseStatus.shared:
        return Colors.orange;
      case SurpriseStatus.archived:
        return Colors.red;
    }
  }
}

/// Surprise stats card for viewing analytics
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Vistas',
                  value: surprise.getViewCount().toString(),
                  icon: Icons.visibility,
                ),
                _StatItem(
                  label: 'Compartidas',
                  value: surprise.getShareCount().toString(),
                  icon: Icons.share,
                ),
                _StatItem(
                  label: 'Creada',
                  value: _formatDate(surprise.createdAt),
                  icon: Icons.calendar_today,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Stat item for displaying a single statistic
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.pink.shade300),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
