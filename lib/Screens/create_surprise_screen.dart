import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:love14/providers/surprise_provider.dart';
import 'package:love14/Widgets/surprise_widgets.dart';

class CreateSurpriseScreen extends StatefulWidget {
  final String userUid;
  final String userName;

  const CreateSurpriseScreen({
    Key? key,
    required this.userUid,
    required this.userName,
  }) : super(key: key);

  @override
  State<CreateSurpriseScreen> createState() => _CreateSurpriseScreenState();
}

class _CreateSurpriseScreenState extends State<CreateSurpriseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // Form fields
  late TextEditingController _recipientNameController;
  late TextEditingController _personalMessageController;
  DateTime? _specialDate;
  String _selectedFlower = 'rose'; // Default flower
  List<String> _selectedFlowerIds = [];
  List<File> _selectedPhotos = [];
  File? _selectedVideo;
  File? _selectedMusic;
  String? _aiLetter;
  bool _wantsMusicOrVideo = false;
  bool _wantsAILetter = false;

  @override
  void initState() {
    super.initState();
    _recipientNameController = TextEditingController();
    _personalMessageController = TextEditingController();
    _selectedFlowerIds = ['rose']; // Default
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _personalMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Sorpresa'),
        elevation: 0,
        backgroundColor: Colors.pink.shade200,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== SECTION 1: BASIC INFO =====
                SectionHeader(title: '1. Información Básica'),
                const SizedBox(height: 16),

                // Recipient name
                TextFormField(
                  controller: _recipientNameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de quien recibe',
                    hintText: 'Ej: María, mi amor',
                    prefixIcon: Icon(Icons.person, color: Colors.pink.shade300),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.pink.shade50,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Special date
                GestureDetector(
                  onTap: () => _selectSpecialDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink.shade300),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.pink.shade50,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.pink.shade300),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha Especial',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.pink.shade300,
                              ),
                            ),
                            Text(
                              _specialDate == null
                                  ? 'Selecciona una fecha'
                                  : '${_specialDate!.day}/${_specialDate!.month}/${_specialDate!.year}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ===== SECTION 2: PERSONAL MESSAGE =====
                SectionHeader(title: '2. Mensaje Personalizado'),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _personalMessageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Tu mensaje',
                    hintText: 'Escribe un mensaje romántico y personalizado...',
                    prefixIcon: Icon(Icons.edit, color: Colors.pink.shade300),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.pink.shade50,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'El mensaje es requerido';
                    }
                    if ((value?.length ?? 0) < 10) {
                      return 'El mensaje debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // ===== SECTION 3: FLOWERS =====
                SectionHeader(title: '3. Flores'),
                const SizedBox(height: 16),

                FlowerSelector(
                  selectedFlowers: _selectedFlowerIds,
                  onFlowersChanged: (flowers) {
                    setState(() {
                      _selectedFlowerIds = flowers;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // ===== SECTION 4: PREMIUM FEATURES =====
                SectionHeader(title: '4. Características Premium'),
                const SizedBox(height: 16),

                // Toggle premium features
                SwitchListTile(
                  title: const Text('Agregar música y video'),
                  subtitle: const Text('Características premium'),
                  value: _wantsMusicOrVideo,
                  onChanged: (value) {
                    setState(() {
                      _wantsMusicOrVideo = value;
                      if (!value) {
                        _selectedMusic = null;
                        _selectedVideo = null;
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),

                if (_wantsMusicOrVideo) ...[
                  // Music picker
                  PremiumFeatureButton(
                    icon: Icons.music_note,
                    title: _selectedMusic == null
                        ? 'Seleccionar música'
                        : 'Música: ${_selectedMusic!.path.split('/').last}',
                    onTap: () => _pickMusic(),
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),

                  // Video picker
                  PremiumFeatureButton(
                    icon: Icons.video_library,
                    title: _selectedVideo == null
                        ? 'Seleccionar video'
                        : 'Video: ${_selectedVideo!.path.split('/').last}',
                    onTap: () => _pickVideo(),
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 12),
                ],

                // Photos
                PremiumFeatureButton(
                  icon: Icons.photo_library,
                  title: _selectedPhotos.isEmpty
                      ? 'Seleccionar fotos'
                      : '${_selectedPhotos.length} foto(s) seleccionada(s)',
                  onTap: () => _pickPhotos(),
                  color: Colors.green,
                ),
                const SizedBox(height: 12),

                // AI Letter
                SwitchListTile(
                  title: const Text('Generar carta romántica con IA'),
                  subtitle: const Text('Características premium'),
                  value: _wantsAILetter,
                  onChanged: (value) {
                    setState(() {
                      _wantsAILetter = value;
                      if (!value) {
                        _aiLetter = null;
                      }
                    });
                  },
                ),

                if (_wantsAILetter && _aiLetter == null) ...[
                  const SizedBox(height: 12),
                  Consumer<SurpriseProvider>(
                    builder: (context, provider, child) {
                      return ElevatedButton.icon(
                        onPressed: provider.isLoading
                            ? null
                            : () => _generateAILetter(context),
                        icon: const Icon(Icons.auto_awesome),
                        label: provider.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Generar con IA'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          minimumSize: const Size.fromHeight(50),
                        ),
                      );
                    },
                  ),
                ],

                if (_aiLetter != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.amber.shade50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Carta IA Generada',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_aiLetter!, style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // ===== PLAN INFO =====
                PlanInfoBox(),
                const SizedBox(height: 32),

                // ===== ACTION BUTTONS =====
                Consumer<SurpriseProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        // Save as draft
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: provider.isLoading
                                ? null
                                : () => _saveDraft(context),
                            child: const Text(
                              'Guardar como borrador',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Create & publish
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: provider.isLoading
                                ? null
                                : () => _createAndPublish(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink.shade300,
                            ),
                            child: provider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Crear y compartir',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===== HELPER METHODS =====

  Future<void> _selectSpecialDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _specialDate = picked;
      });
    }
  }

  Future<void> _pickPhotos() async {
    final result = await _imagePicker.pickMultiImage();
    if (result.isNotEmpty) {
      setState(() {
        _selectedPhotos = result.map((e) => File(e.path)).toList();
      });
    }
  }

  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() {
        _selectedVideo = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickMusic() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() {
        _selectedMusic = File(result.files.single.path!);
      });
    }
  }

  Future<void> _generateAILetter(BuildContext context) async {
    final provider = context.read<SurpriseProvider>();

    final letter = await provider.generateAILetter(
      recipientName: _recipientNameController.text,
      senderName: widget.userName,
      personalMessage: _personalMessageController.text,
      specialDate: _specialDate ?? DateTime.now(),
    );

    if (letter != null) {
      setState(() {
        _aiLetter = letter;
      });
    }
  }

  Future<void> _saveDraft(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_specialDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha especial')),
      );
      return;
    }

    final provider = context.read<SurpriseProvider>();

    // Upload media if exists
    String? musicUrl;
    String? videoUrl;
    List<String> photoUrls = [];

    // (Uploads happen when saving draft - implement as needed)

    final surprise = await provider.createSurprise(
      userUid: widget.userUid,
      userName: widget.userName,
      recipientName: _recipientNameController.text,
      personalMessage: _personalMessageController.text,
      flowerType: _selectedFlower,
      flowerIds: _selectedFlowerIds,
      specialDate: _specialDate!,
      musicUrl: musicUrl,
      photoUrls: photoUrls,
      videoUrl: videoUrl,
      aiLetter: _aiLetter,
    );

    if (surprise != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorpresa guardada como borrador')),
        );
        Navigator.pop(context, surprise);
      }
    }
  }

  Future<void> _createAndPublish(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_specialDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha especial')),
      );
      return;
    }

    final provider = context.read<SurpriseProvider>();

    // Create surprise
    final surprise = await provider.createSurprise(
      userUid: widget.userUid,
      userName: widget.userName,
      recipientName: _recipientNameController.text,
      personalMessage: _personalMessageController.text,
      flowerType: _selectedFlower,
      flowerIds: _selectedFlowerIds,
      specialDate: _specialDate!,
      aiLetter: _aiLetter,
    );

    if (surprise != null) {
      // Publish
      await provider.publishSurprise(
        userUid: widget.userUid,
        surpriseId: surprise.surpriseId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Sorpresa creada y compartida!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, surprise);
      }
    }
  }
}
