import 'package:flutter/material.dart';
import 'package:love14/providers/surprise_provider.dart';
import 'package:provider/provider.dart';
import 'package:love14/Screens/create_surprise_screen.dart';
import 'package:love14/Screens/surprise_view_screen.dart';
import 'package:love14/Widgets/surprise_widgets.dart';

class MySurprisesScreen extends StatefulWidget {
  final String userUid;
  final String userName;

  const MySurprisesScreen({
    Key? key,
    required this.userUid,
    required this.userName,
  }) : super(key: key);

  @override
  State<MySurprisesScreen> createState() => _MySurprisesScreenState();
}

class _MySurprisesScreenState extends State<MySurprisesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSurprises();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadSurprises() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SurpriseProvider>().loadMySurprises(widget.userUid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Sorpresas'),
        backgroundColor: Colors.pink.shade200,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Borradores'),
            Tab(text: 'Publicadas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ALL SURPRISES
          _buildSurprisesList(context, null),

          // DRAFTS
          _buildSurprisesList(context, 'draft'),

          // PUBLISHED
          _buildSurprisesList(context, 'published'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade300,
        onPressed: () => _navigateToCreate(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSurprisesList(BuildContext context, String? statusFilter) {
    return Consumer<SurpriseProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var surprises = provider?.mySurprises ?? [];

        // Filter by status
        if (statusFilter != null) {
          surprises = surprises
              .where((s) => s.status.toString().split('.').last == statusFilter)
              .toList();
        }

        if (surprises.isEmpty) {
          return EmptyState(
            title: 'No hay sorpresas',
            subtitle: statusFilter == 'draft'
                ? 'Crea una sorpresa nueva'
                : 'Publica una sorpresa para compartirla',
            icon: Icons.card_giftcard,
            onAction: () => _navigateToCreate(context),
            actionLabel: 'Crear Sorpresa',
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.refresh(widget.userUid),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surprises.length,
            itemBuilder: (context, index) {
              final surprise = surprises[index];
              return SurpriseCard(
                surprise: surprise,
                onTap: () => _navigateToView(context, surprise.surpriseId),
                onPublish: surprise.status.toString().split('.').last == 'draft'
                    ? () => _publishSurprise(context, surprise.surpriseId)
                    : null,
                onDelete: () => _deleteSurprise(context, surprise.surpriseId),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToCreate(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateSurpriseScreen(
          userUid: widget.userUid,
          userName: widget.userName,
        ),
      ),
    );

    if (result != null) {
      _loadSurprises();
    }
  }

  void _navigateToView(BuildContext context, String surpriseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurpriseViewScreen(surpriseId: surpriseId),
      ),
    );
  }

  Future<void> _publishSurprise(
      BuildContext context, String surpriseId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publicar Sorpresa'),
        content: const Text(
          '¿Estás seguro de que quieres publicar esta sorpresa? '
          'Será visible en el enlace público.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Publicar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = context.read<SurpriseProvider>();
      final success = await provider.publishSurprise(
        userUid: widget.userUid,
        surpriseId: surpriseId,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Sorpresa publicada!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _deleteSurprise(
      BuildContext context, String surpriseId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Sorpresa'),
        content: const Text(
          '¿Estás seguro de que quieres eliminar esta sorpresa? '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = context.read<SurpriseProvider>();
      final success = await provider.deleteSurprise(
        userUid: widget.userUid,
        surpriseId: surpriseId,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sorpresa eliminada'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
