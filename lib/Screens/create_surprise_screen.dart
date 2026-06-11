import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:love14/Controllers/surprise_controller.dart';
import 'package:love14/Controllers/poem_controller.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:love14/models/flower_model.dart';
import 'package:love14/Utils/app_colors.dart';
import 'package:love14/Utils/app_styles.dart';
import 'package:love14/Widgets/romantic_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateSurpriseScreen extends StatefulWidget {
  final String? surpriseIdToEdit;

  const CreateSurpriseScreen({
    super.key,
    this.surpriseIdToEdit,
    required String userId,
  });

  @override
  State<CreateSurpriseScreen> createState() => _CreateSurpriseScreenState();
}

class _CreateSurpriseScreenState extends State<CreateSurpriseScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _creatorNameController;
  late TextEditingController _recipientNameController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _customMessageController;

  // State variables
  FlowerType? _selectedFlower;
  List<String> _selectedPhotoUrls = [];
  String? _selectedVideoUrl;
  String? _selectedMusic;
  String? _selectedPoemId;
  DateTime? _specialDate;
  bool _isLoading = false;
  bool _isUploadingPhotos = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _creatorNameController = TextEditingController();
    _recipientNameController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _customMessageController = TextEditingController();

    // Get current user name
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      _creatorNameController.text = user.displayName!;
    }
  }

  @override
  void dispose() {
    _creatorNameController.dispose();
    _recipientNameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _customMessageController.dispose();
    super.dispose();
  }

  // ============ PICK IMAGES ============

  Future<void> _pickPhotos() async {
    try {
      final result = await ImagePicker().pickMultiImage(
        maxHeight: 1080,
        maxWidth: 1080,
        imageQuality: 85,
      );

      if (result.isEmpty) return;

      if (mounted) {
        setState(() {
          _isUploadingPhotos = true;
        });
      }

      // TODO: Upload to Firebase Storage and get URLs
      // For now, we'll use local paths (implement storage upload in next phase)
      final photoUrls = result.map((xFile) => xFile.path).toList();

      if (mounted) {
        setState(() {
          _selectedPhotoUrls = photoUrls;
          _isUploadingPhotos = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error seleccionando fotos: $e')),
        );
      }
    }
  }

  // ============ PICK VIDEO ============

  Future<void> _pickVideo() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowCompression: true,
      );

      if (result == null || result.files.isEmpty) return;

      // Check premium
      if (!context.read<SurpriseController>().isPremiumUser) {
        if (mounted) {
          _showPremiumAlert(
            'Vídeos',
            'Los vídeos están disponibles en plan Premium',
          );
        }
        return;
      }

      // TODO: Upload to Firebase Storage
      final videoPath = result.files.first.path;

      if (mounted) {
        setState(() {
          _selectedVideoUrl = videoPath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error seleccionando vídeo: $e')),
        );
      }
    }
  }

  // ============ PICK MUSIC ============

  Future<void> _pickMusic() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.audio);

      if (result == null || result.files.isEmpty) return;

      // Check premium
      if (!context.read<SurpriseController>().isPremiumUser) {
        if (mounted) {
          _showPremiumAlert(
            'Música personalizada',
            'La música personalizada está disponible en plan Premium',
          );
        }
        return;
      }

      // TODO: Upload to Firebase Storage
      final musicPath = result.files.first.path;

      if (mounted) {
        setState(() {
          _selectedMusic = musicPath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error seleccionando música: $e')),
        );
      }
    }
  }

  // ============ DATE PICKER ============

  Future<void> _pickSpecialDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryYellow,
              onPrimary: AppColors.darkText,
              surface: AppColors.lightBackground,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _specialDate = pickedDate;
      });
    }
  }

  // ============ CREATE SURPRISE ============

  Future<void> _createSurprise() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFlower == null) {
      _showError('Por favor selecciona una flor');
      return;
    }

    if (_specialDate == null) {
      _showError('Por favor selecciona una fecha especial');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final controller = context.read<SurpriseController>();

      // Check if can create
      final canCreate = await controller.canCreateSurprise(
        FirebaseAuth.instance.currentUser!.uid,
      );

      if (!canCreate && mounted) {
        _showError(controller.errorMessage ?? 'No puedes crear más sorpresas');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create surprise
      final surprise = await controller.createSurpriseDraft(
        creatorName: _creatorNameController.text.trim(),
        recipientName: _recipientNameController.text.trim(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        flowerType: _selectedFlower!,
        specialDate: _specialDate,
      );

      if (surprise != null && mounted) {
        // Update with additional data
        await controller.updateSurpriseDraft(
          surpriseId: surprise.surpriseId,
          customMessage: _customMessageController.text.isNotEmpty
              ? _customMessageController.text.trim()
              : null,
          photoUrls: _selectedPhotoUrls.isNotEmpty ? _selectedPhotoUrls : null,
          videoUrl: _selectedVideoUrl,
          musicUrl: _selectedMusic,
        );

        // Navigate to view screen
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(
            '/surprise-view',
            arguments: surprise.surpriseId,
          );
        }
      } else if (mounted) {
        _showError(controller.errorMessage ?? 'Error creando sorpresa');
      }
    } catch (e) {
      if (mounted) {
        _showError('Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============ UI HELPERS ============

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.errorRed),
    );
  }

  void _showPremiumAlert(String feature, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBackground,
        title: const Text('Plan Premium'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/premium-plans');
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  // ============ BUILD ============

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isPremium = context.watch<SurpriseController>().isPremiumUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Sorpresa'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============ SECTION: PERSONAS ============
                _buildSectionTitle('De quién a quién'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _creatorNameController,
                        decoration: _buildInputDecoration('Tu nombre'),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Campo requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _recipientNameController,
                        decoration: _buildInputDecoration('Para quién'),
                        validator: (value) =>
                            value?.isEmpty ?? true ? 'Campo requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ============ SECTION: TÍTULO Y DESCRIPCIÓN ============
                _buildSectionTitle('Detalles de la Sorpresa'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: _buildInputDecoration(
                    'Título romántico',
                    hintText: 'Ej: Te amo más que ayer',
                  ),
                  maxLines: 1,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'El título es requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: _buildInputDecoration(
                    'Descripción',
                    hintText: 'Cuéntale qué representa esta sorpresa',
                  ),
                  maxLines: 3,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'La descripción es requerida'
                      : null,
                ),
                const SizedBox(height: 24),

                // ============ SECTION: FLOR ============
                _buildSectionTitle('Elige una Flor'),
                const SizedBox(height: 16),
                _buildFlowerSelector(),
                const SizedBox(height: 24),

                // ============ SECTION: FECHA ESPECIAL ============
                _buildSectionTitle('Fecha Especial'),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickSpecialDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryPink),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.primaryPink,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _specialDate == null
                              ? 'Selecciona una fecha'
                              : '${_specialDate!.day}/${_specialDate!.month}/${_specialDate!.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ============ SECTION: MENSAJE ============
                _buildSectionTitle('Mensaje Personalizado'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customMessageController,
                  decoration: _buildInputDecoration(
                    'Tu mensaje',
                    hintText: 'Escribe un mensaje especial...',
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),

                // ============ SECTION: FOTOS ============
                _buildSectionTitle('Fotos'),
                const SizedBox(height: 16),
                _buildPhotoSection(isPremium),
                const SizedBox(height: 24),

                // ============ SECTION: VÍDEO (Premium) ============
                if (isPremium) ...[
                  _buildSectionTitle('Vídeo (Premium)'),
                  const SizedBox(height: 16),
                  _buildVideoSection(),
                  const SizedBox(height: 24),
                ],

                // ============ SECTION: MÚSICA (Premium) ============
                if (isPremium) ...[
                  _buildSectionTitle('Música (Premium)'),
                  const SizedBox(height: 16),
                  _buildMusicSection(),
                  const SizedBox(height: 24),
                ],

                // ============ SECTION: POEMA ============
                _buildSectionTitle('Selecciona un Poema'),
                const SizedBox(height: 16),
                _buildPoemSelector(),
                const SizedBox(height: 32),

                // ============ PREVIEW CARD ============
                _buildPreviewCard(),
                const SizedBox(height: 32),

                // ============ BUTTONS ============
                if (!_isLoading)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _createSurprise,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPink,
                          ),
                          child: const Text(
                            'Crear Sorpresa',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryPink,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ WIDGET BUILDERS ============

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, {String? hintText}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primaryPink, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.primaryPink),
    );
  }

  Widget _buildFlowerSelector() {
    return GridView.count(
      crossAxisCount: 5,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: FlowerType.values
          .map((flower) => _buildFlowerCard(flower))
          .toList(),
    );
  }

  Widget _buildFlowerCard(FlowerType flower) {
    final isSelected = _selectedFlower == flower;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFlower = flower;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryPink : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? AppColors.primaryPink.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(flower.emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              flower.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(bool isPremium) {
    final maxPhotos = isPremium ? 20 : 1;
    return Column(
      children: [
        if (!isPremium)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightYellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: AppColors.warmBrown),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Plan gratis: máximo $maxPhotos foto',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.warmBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        if (_selectedPhotoUrls.isNotEmpty)
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: _selectedPhotoUrls
                .asMap()
                .entries
                .map((entry) => _buildPhotoThumbnail(entry.key, entry.value))
                .toList(),
          ),
        if (_selectedPhotoUrls.length < maxPhotos) const SizedBox(height: 12),
        if (_selectedPhotoUrls.length < maxPhotos)
          OutlinedButton.icon(
            onPressed: _isUploadingPhotos ? null : _pickPhotos,
            icon: const Icon(Icons.photo_library),
            label: Text(
              _isUploadingPhotos
                  ? 'Subiendo (${(_uploadProgress * 100).toStringAsFixed(0)}%)'
                  : 'Agregar Fotos',
            ),
          ),
      ],
    );
  }

  Widget _buildPhotoThumbnail(int index, String photoUrl) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: Image.asset(photoUrl, fit: BoxFit.cover),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedPhotoUrls.removeAt(index);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.errorRed,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoSection() {
    return Column(
      children: [
        if (_selectedVideoUrl != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.deepGreen),
            ),
            child: Row(
              children: [
                const Icon(Icons.video_library, color: AppColors.deepGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedVideoUrl!.split('/').last,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.deepGreen),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedVideoUrl = null;
                    });
                  },
                  child: const Icon(Icons.close, color: AppColors.deepGreen),
                ),
              ],
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: _pickVideo,
            icon: const Icon(Icons.video_library),
            label: const Text('Agregar Vídeo'),
          ),
      ],
    );
  }

  Widget _buildMusicSection() {
    return Column(
      children: [
        if (_selectedMusic != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.deepGreen),
            ),
            child: Row(
              children: [
                const Icon(Icons.music_note, color: AppColors.deepGreen),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedMusic!.split('/').last,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.deepGreen),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMusic = null;
                    });
                  },
                  child: const Icon(Icons.close, color: AppColors.deepGreen),
                ),
              ],
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: _pickMusic,
            icon: const Icon(Icons.music_note),
            label: const Text('Agregar Música'),
          ),
      ],
    );
  }

  Widget _buildPoemSelector() {
    return Consumer<PoemController>(
      builder: (context, poemController, _) {
        if (poemController.poems.isEmpty) {
          return const Center(child: Text('No hay poemas disponibles'));
        }

        return DropdownButtonFormField<String>(
          value: _selectedPoemId,
          items: poemController.poems
              .map(
                (poem) =>
                    DropdownMenuItem(value: poem.id, child: Text(poem.title)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedPoemId = value;
            });
          },
          decoration: _buildInputDecoration('Elige un poema'),
        );
      },
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryPink),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.lightBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vista Previa',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 12),
          if (_selectedFlower != null)
            Text(
              '${_selectedFlower!.emoji} ${_selectedFlower!.displayName}',
              style: const TextStyle(fontSize: 18),
            ),
          const SizedBox(height: 8),
          if (_titleController.text.isNotEmpty)
            Text(
              _titleController.text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 8),
          if (_specialDate != null)
            Text(
              'Para: ${_specialDate!.day}/${_specialDate!.month}/${_specialDate!.year}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primaryPink,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (_selectedPhotoUrls.isNotEmpty)
                Chip(label: Text('📸 ${_selectedPhotoUrls.length} foto(s)')),
              const SizedBox(width: 8),
              if (_selectedVideoUrl != null)
                const Chip(label: Text('🎬 Vídeo')),
              const SizedBox(width: 8),
              if (_selectedMusic != null) const Chip(label: Text('🎵 Música')),
            ],
          ),
        ],
      ),
    );
  }
}
