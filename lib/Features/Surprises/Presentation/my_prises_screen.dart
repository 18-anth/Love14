import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:love14/Features/Surprises/Providers/surprise_provider.dart';
import 'package:love14/Features/Surprises/Widgets/surprise_widgets.dart';
import 'package:love14/Features/Surprises/Presentation/surprise_view_screen.dart';

class MyPrisesScreen extends StatefulWidget {
  final String userId;

  const MyPrisesScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MyPrisesScreen> createState() => _MyPrisesScreenState();
}

class _MyPrisesScreenState extends State<MyPrisesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SurpriseProvider>().refreshSurprises(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Sorpresas'),
        backgroundColor: Colors.pink.shade400,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<SurpriseProvider>().refreshSurprises(widget.userId);
            },
          ),
        ],
      ),
      body: Consumer<SurpriseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.userSurprises.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes sorpresas aún',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Sorpresa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
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

          return RefreshIndicator(
            onRefresh: () => provider.refreshSurprises(widget.userId),
            child: ListView.builder(
              itemCount: provider.userSurprises.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final surprise = provider.userSurprises[index];

                return SurpriseCard(
                  surprise: surprise,
                  onTap: () {
                    // Navigate to view surprise
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurpriseViewScreen(
                          surpriseId: surprise.surpriseId,
                          isPublicView: false,
                        ),
                      ),
                    );
                  },
                  onShare: () => _shareSurprise(surprise),
                  onDelete: () => _showDeleteConfirm(context, provider, surprise.surpriseId),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareSurprise(var surprise) async {
    Share.share(
      'Mira la sorpresa que ${surprise.creatorName} creó para ti: ${surprise.publicUrl}',
      subject: 'Sorpresa especial: ${surprise.title}',
    );
  }

  void _showDeleteConfirm(BuildContext context, SurpriseProvider provider, String surpriseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Sorpresa'),
        content: const Text('¿Estás seguro? No se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteSurprise(surpriseId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
