import 'package:flutter/material.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:provider/provider.dart';
import 'package:love14/providers/surprise_provider.dart';
import 'package:love14/Widgets/surprise_widgets.dart';
import 'package:share_plus/share_plus.dart';

class SurpriseViewScreen extends StatefulWidget {
  final String surpriseId;
  final String? slug; // For public URL access

  const SurpriseViewScreen({
    Key? key,
    this.surpriseId = '',
    this.slug,
  }) : super(key: key);

  @override
  State<SurpriseViewScreen> createState() => _SurpriseViewScreenState();
}

class _SurpriseViewScreenState extends State<SurpriseViewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showQRCode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSurprise();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadSurprise() {
    final provider = context.read<SurpriseProvider>();
    if (widget.slug != null) {
      provider.loadPublicSurprise(widget.slug!);
    } else {
      provider.loadSurpriseById(widget.surpriseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SurpriseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text('Cargando sorpresa...'),
                ],
              ),
            );
          }

          if (provider.currentSurprise == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 20),
                  const Text('Sorpresa no encontrada'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            );
          }

          final surprise = provider.currentSurprise!;

          return CustomScrollView(
            slivers: [
              // ===== APP BAR =====
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: Colors.pink.shade200,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(surprise.recipientName),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.pink.shade300,
                          Colors.pink.shade100,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Flower animation placeholder
                        Center(
                          child: Icon(
                            Icons.favorite,
                            size: 100,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        // View counter
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.visibility, size: 16),
                                const SizedBox(width: 6),
                                Text('${surprise.viewCount}'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _shareLink(surprise),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_2),
                    onPressed: () {
                      setState(() {
                        _showQRCode = !_showQRCode;
                      });
                    },
                  ),
                ],
              ),

              // ===== MAIN CONTENT =====
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // QR Code section
                    if (_showQRCode && surprise.qrCode != null) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        color: Colors.grey.shade100,
                        child: Column(
                          children: [
                            const Text(
                              'Código QR para compartir',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // QR Code image would go here
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.pink),
                              ),
                              child: Center(
                                child: Text(
                                  'QR: ${surprise.publicUrl}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Tabs
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.pink,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.pink,
                      tabs: const [
                        Tab(text: 'Mensaje'),
                        Tab(text: 'Media'),
                        Tab(text: 'Carta'),
                      ],
                    ),

                    SizedBox(
                      height: 400,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // TAB 1: MESSAGE
                          _buildMessageTab(surprise),

                          // TAB 2: MEDIA
                          _buildMediaTab(surprise),

                          // TAB 3: LETTER
                          _buildLetterTab(surprise),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Information section
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Información de la Sorpresa',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _infoRow(
                            'De:',
                            surprise.creatorName,
                            Icons.person,
                          ),
                          const SizedBox(height: 8),
                          _infoRow(
                            'Para:',
                            surprise.recipientName,
                            Icons.favorite,
                          ),
                          const SizedBox(height: 8),
                          _infoRow(
                            'Fecha especial:',
                            '${surprise.specialDate.day}/${surprise.specialDate.month}/${surprise.specialDate.year}',
                            Icons.calendar_today,
                          ),
                          const SizedBox(height: 8),
                          _infoRow(
                            'Días para fecha especial:',
                            '${surprise.daysUntilSpecialDate()} días',
                            Icons.schedule,
                          ),
                          const SizedBox(height: 8),
                          _infoRow(
                            'Plan:',
                            surprise.planType == PlanType.premium
                                ? 'Premium ⭐'
                                : 'Gratis',
                            Icons.card_giftcard,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===== TAB BUILDERS =====

  Widget _buildMessageTab(SurpriseModel surprise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pink.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Querida ${surprise.recipientName},',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  surprise.personalMessage,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Con amor,\n${surprise.creatorName}',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.pink.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTab(SurpriseModel surprise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flowers
          if (surprise.flowerIds.isNotEmpty) ...[
            const Text(
              'Flores',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_florist, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    '${surprise.flowerIds.length} ${surprise.flowerType}(s)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Photos
          if (surprise.photoUrls.isNotEmpty) ...[
            const Text(
              'Fotografías',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: surprise.photoUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: Icon(Icons.image, color: Colors.grey.shade400),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          // Music
          if (surprise.musicUrl != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Música de fondo incluida')),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Video
          if (surprise.videoUrl != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.video_library, color: Colors.purple),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Video incluido')),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLetterTab(SurpriseModel surprise) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (surprise.aiLetter != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.amber),
                      const SizedBox(width: 8),
                      const Text(
                        'Carta Romántica',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    surprise.aiLetter!,
                    style: const TextStyle(
                      height: 1.8,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ] else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No hay carta romántica en esta sorpresa',
                style: TextStyle(color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  // ===== HELPER WIDGETS =====

  Widget _infoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.amber.shade700),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  void _shareLink(SurpriseModel surprise) {
    Share.share(
      '¡Te dejé una sorpresa romántica! 💝\n\n${surprise.publicUrl}',
      subject: 'Una sorpresa especial para ti',
    );
  }
}
