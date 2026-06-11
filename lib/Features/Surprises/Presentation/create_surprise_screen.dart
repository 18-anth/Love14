import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:love14/Features/Surprises/Domain/models/flower_model.dart';
import 'package:love14/Features/Surprises/Providers/surprise_provider.dart';
import 'package:love14/Features/Surprises/Widgets/flower_widgets.dart';
import 'package:love14/Features/Surprises/Widgets/premium_widgets.dart';

class CreateSurpriseScreen extends StatefulWidget {
  final String userId;

  const CreateSurpriseScreen({
    super.key,
    required this.userId,
  });

  @override
  State<CreateSurpriseScreen> createState() => _CreateSurpriseScreenState();
}

class _CreateSurpriseScreenState extends State<CreateSurpriseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientNameCtrl = TextEditingController();
  final _creatorNameCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _customMessageCtrl = TextEditingController();

  late Flower _selectedFlower;
  DateTime? _selectedDate;
  int _currentStep = 0;
  bool _aiLetterRequested = false;

  @override
  void initState() {
    super.initState();
    _selectedFlower = Flower(type: FlowerType.rosa);
  }

  @override
  void dispose() {
    _recipientNameCtrl.dispose();
    _creatorNameCtrl.dispose();
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    _customMessageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Sorpresa'),
        backgroundColor: Colors.pink.shade400,
        elevation: 0,
      ),
      body: Consumer<SurpriseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${provider.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.clearMessages(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return Stepper(
            currentStep: _currentStep,
            onStepTapped: (step) {
              if (step < _currentStep || step == _currentStep) {
                setState(() => _currentStep = step);
              }
            },
            steps: [
              // Step 1: Información Básica
              Step(
                title: const Text('Información'),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                content: _buildBasicInfoStep(provider),
              ),

              // Step 2: Flor y Detalles
              Step(
                title: const Text('Flor'),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                content: _buildFlowerStep(provider),
              ),

              // Step 3: Contenido Multimedia (Premium)
              Step(
                title: const Text('Multimedia'),
                isActive: _currentStep >= 2,
                state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                content: _buildMultimediaStep(provider),
              ),

              // Step 4: Carta y Revisión
              Step(
                title: const Text('Carta'),
                isActive: _currentStep >= 3,
                state: _currentStep > 3 ? StepState.complete : StepState.indexed,
                content: _buildLetterStep(provider),
              ),

              // Step 5: Publicar
              Step(
                title: const Text('Publicar'),
                isActive: _currentStep >= 4,
                state: _currentStep > 4 ? StepState.complete : StepState.indexed,
                content: _buildPublishStep(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoStep(SurpriseProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _creatorNameCtrl,
            decoration: InputDecoration(
              labelText: 'Tu nombre',
              hintText: 'Juan',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _recipientNameCtrl,
            decoration: InputDecoration(
              labelText: 'Nombre de quien recibe',
              hintText: 'María',
              prefixIcon: const Icon(Icons.favorite),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleCtrl,
            decoration: InputDecoration(
              labelText: 'Título de la sorpresa',
              hintText: 'Sorpresa para María',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionCtrl,
            decoration: InputDecoration(
              labelText: 'Descripción',
              hintText: 'Describir la sorpresa...',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              hintMaxLines: 3,
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          // Date Picker
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Fecha especial',
                prefixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _selectedDate == null
                    ? 'Seleccionar fecha'
                    : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                style: TextStyle(
                  color: _selectedDate == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && _selectedDate != null) {
                  setState(() => _currentStep = 1);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Siguiente', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowerStep(SurpriseProvider provider) {
    return Column(
      children: [
        FlowerSelector(
          selectedFlower: _selectedFlower,
          onFlowerSelected: (flower) {
            setState(() => _selectedFlower = flower);
          },
        ),
        const SizedBox(height: 32),
        if (!provider.isPremium)
          const FreemiumLimitBanner(
            current: 1,
            limit: 1,
            itemName: 'flor',
          ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 0),
                child: const Text('Atrás'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  provider.startNewSurprise(
                    creatorId: widget.userId,
                    recipientName: _recipientNameCtrl.text,
                    creatorName: _creatorNameCtrl.text,
                    title: _titleCtrl.text,
                    description: _descriptionCtrl.text,
                    flower: _selectedFlower,
                    specialDate: _selectedDate!,
                  );

                  if (provider.draftSurprise != null) {
                    setState(() => _currentStep = 2);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                child: const Text('Siguiente', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMultimediaStep(SurpriseProvider provider) {
    return Column(
      children: [
        if (!provider.isPremium) ...[
          const FreemiumLimitBanner(
            current: 0,
            limit: 0,
            itemName: 'media',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              border: Border.all(color: Colors.amber),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  '✨ Características Premium',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Desbloquea fotos, videos y música personalizada con Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showUpgradeDialog(context, provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: const Text(
                      'Mejorar a Premium',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          // Premium multimedia options
          _MediaUploadSection(
            title: 'Fotos',
            icon: Icons.image,
            count: provider.photoUrls.length,
            onAdd: () => _pickPhotos(provider),
          ),
          const SizedBox(height: 16),
          _MediaUploadSection(
            title: 'Video',
            icon: Icons.videocam,
            hasItem: provider.videoUrl != null,
            onAdd: () => _pickVideo(provider),
          ),
          const SizedBox(height: 16),
          _MediaUploadSection(
            title: 'Música',
            icon: Icons.music_note,
            hasItem: provider.musicUrl != null,
            onAdd: () => _pickMusic(provider),
          ),
        ],
        const SizedBox(height: 24),
        TextFormField(
          controller: _customMessageCtrl,
          decoration: InputDecoration(
            labelText: 'Mensaje personalizado (opcional)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            hintMaxLines: 3,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 1),
                child: const Text('Atrás'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = 3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                child: const Text('Siguiente', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLetterStep(SurpriseProvider provider) {
    return Column(
      children: [
        if (!provider.isPremium) ...[
          const FreemiumLimitBanner(
            current: 0,
            limit: 0,
            itemName: 'cartas IA',
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                const Text(
                  '🤖 Cartas Generadas por IA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Genera cartas románticas personalizadas con IA',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showUpgradeDialog(context, provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Mejorar a Premium',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Generar Carta con IA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_aiLetterRequested && provider.aiLetter != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        border: Border.all(color: Colors.pink.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        provider.aiLetter!,
                        style: const TextStyle(fontSize: 14, height: 1.6),
                      ),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() => _aiLetterRequested = true);
                          provider.generateAILetter(
                            occasion: _titleCtrl.text,
                          );
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Generar con IA'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 2),
                child: const Text('Atrás'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => setState(() => _currentStep = 4),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                child: const Text('Siguiente', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPublishStep(SurpriseProvider provider) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen de la Sorpresa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _SummaryRow('De:', _creatorNameCtrl.text),
                _SummaryRow('Para:', _recipientNameCtrl.text),
                _SummaryRow('Título:', _titleCtrl.text),
                _SummaryRow('Flor:', _selectedFlower.type.displayName),
                _SummaryRow('Fecha:', DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                if (provider.photoUrls.isNotEmpty)
                  _SummaryRow('Fotos:', '${provider.photoUrls.length} archivos'),
                if (provider.videoUrl != null)
                  _SummaryRow('Video:', 'Agregado'),
                if (provider.musicUrl != null)
                  _SummaryRow('Música:', 'Agregada'),
                if (provider.aiLetter != null)
                  _SummaryRow('Carta IA:', 'Generada'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              provider.publishSurprise();
              if (provider.currentSurprise != null) {
                _showPublishSuccess(context, provider.currentSurprise!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('🎉 Publicar Sorpresa', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _pickPhotos(SurpriseProvider provider) async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 80);

    if (images.isNotEmpty) {
      for (var image in images) {
        await provider.addPhotos([image.path]);
      }
    }
  }

  void _pickVideo(SurpriseProvider provider) async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      await provider.addVideo(video.path);
    }
  }

  void _pickMusic(SurpriseProvider provider) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      await provider.addMusic(result.files.first.path!);
    }
  }

  void _showUpgradeDialog(BuildContext context, SurpriseProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mejorar a Premium'),
        content: const Text('Esta función está disponible solo en el plan Premium'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.upgradeToPremium(widget.userId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
            ),
            child: const Text('Mejorar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPublishSuccess(BuildContext context, var surprise) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¡Sorpresa Publicada!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            const Text('Tu sorpresa ha sido publicada exitosamente'),
            const SizedBox(height: 16),
            SelectableText(
              surprise.publicUrl,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                backgroundColor: Color(0xFFf0f0f0),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }
}

class _MediaUploadSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;
  final bool hasItem;
  final VoidCallback onAdd;

  const _MediaUploadSection({
    required this.title,
    required this.icon,
    this.count = 0,
    this.hasItem = false,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.pink),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (count > 0)
                      Text('$count archivos', style: const TextStyle(fontSize: 12)),
                    if (hasItem)
                      Text('Agregado', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
