import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:love14/Controllers/surprise_controller.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:love14/Utils/app_colors.dart';
import 'package:love14/Widgets/surprise_card.dart';

class SurpriseHistoryScreen extends StatefulWidget {
  const SurpriseHistoryScreen({super.key});

  @override
  State<SurpriseHistoryScreen> createState() => _SurpriseHistoryScreenState();
}

class _SurpriseHistoryScreenState extends State<SurpriseHistoryScreen> {
  String _filterStatus = 'all'; // all, draft, published, viewed, archived

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Sorpresas'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create-surprise');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  _buildFilterChip('all', 'Todas'),
                  const SizedBox(width: 8),
                  _buildFilterChip('draft', 'Borradores'),
                  const SizedBox(width: 8),
                  _buildFilterChip('published', 'Publicadas'),
                  const SizedBox(width: 8),
                  _buildFilterChip('viewed', 'Vistas'),
                  const SizedBox(width: 8),
                  _buildFilterChip('archived', 'Archivadas'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Surprises list
          Expanded(
            child: Consumer<SurpriseController>(
              builder: (context, controller, _) {
                final surprises = controller.getUserSurprises();

                // Filter surprises
                final filtered = _filterStatus == 'all'
                    ? surprises
                    : surprises
                        .where((s) => s.status.toString().split('.').last == _filterStatus)
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.card_giftcard_outlined,
                          size: 80,
                          color: AppColors.primaryPink,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No hay sorpresas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getEmptyMessage(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/create-surprise');
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Crear Sorpresa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final surprise = filtered[index];
                    return SurpriseCard(
                      surprise: surprise,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/surprise-view',
                          arguments: {
                            'surpriseId': surprise.surpriseId,
                            'isPublic': surprise.status == SurpriseStatus.published,
                          },
                        );
                      },
                      onDelete: () {
                        _showDeleteConfirmation(context, surprise.surpriseId);
                      },
                      showStats: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: AppColors.primaryPink,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.darkText,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primaryPink : Colors.grey[300]!,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String surpriseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Eliminar sorpresa'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta sorpresa? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<SurpriseController>()
                  .deleteSurprise(surpriseId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sorpresa eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  String _getEmptyMessage() {
    switch (_filterStatus) {
      case 'draft':
        return 'No hay borradores';
      case 'published':
        return 'No hay sorpresas publicadas';
      case 'viewed':
        return 'Nadie ha visto tus sorpresas aún';
      case 'archived':
        return 'No hay sorpresas archivadas';
      default:
        return 'Crea una sorpresa para empezar';
    }
  }
}
