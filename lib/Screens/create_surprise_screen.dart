import 'package:flutter/material.dart';
import 'package:love14/models/flower_model.dart';
import 'package:love14/providers/surprise_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CreateSurpriseScreen extends StatefulWidget {
  final String userId;

  const CreateSurpriseScreen({super.key, required this.userId});

  @override
  State<CreateSurpriseScreen> createState() => _CreateSurpriseScreenState();
}

class _CreateSurpriseScreenState extends State<CreateSurpriseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientNameCtrl = TextEditingController();
  final _creatorNameCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  late FlowerType _selectedFlowerType;
  DateTime? _selectedDate;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _selectedFlowerType = FlowerType.rosa;
  }

  @override
  void dispose() {
    _recipientNameCtrl.dispose();
    _creatorNameCtrl.dispose();
    _titleCtrl.dispose();
    _messageCtrl.dispose();
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
                    onPressed: () => provider.clearError(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Stepper(
              currentStep: _currentStep,
              onStepTapped: (step) {
                if (step < _currentStep || step == _currentStep) {
                  setState(() => _currentStep = step);
                }
              },
              steps: [
                Step(
                  title: const Text('Información'),
                  isActive: _currentStep >= 0,
                  state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                  content: _buildInfoStep(provider),
                ),
                Step(
                  title: const Text('Flor'),
                  isActive: _currentStep >= 1,
                  state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                  content: _buildFlowerStep(provider),
                ),
                Step(
                  title: const Text('Revisar'),
                  isActive: _currentStep >= 2,
                  state: _currentStep > 2 ? StepState.complete : StepState.indexed,
                  content: _buildReviewStep(provider),
                ),
              ],
              onStepContinue: () {
                if (_currentStep < 2) {
                  setState(() => _currentStep++);
                } else {
                  _createSurprise(context, provider);
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep--);
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoStep(SurpriseProvider provider) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _creatorNameCtrl,
            decoration: const InputDecoration(
              labelText: 'Tu nombre',
              border: OutlineInputBorder(),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _recipientNameCtrl,
            decoration: const InputDecoration(
              labelText: 'Nombre del destinatario',
              border: OutlineInputBorder(),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Título de la sorpresa',
              border: OutlineInputBorder(),
            ),
            validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _messageCtrl,
            decoration: const InputDecoration(
              labelText: 'Mensaje personalizado',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (v) => v?.isEmpty ?? true ? 'Requerido' : null,
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Fecha especial'),
            subtitle: Text(
              _selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                  : 'Seleccionar fecha',
            ),
            onTap: _pickDate,
            trailing: const Icon(Icons.calendar_today),
          ),
        ],
      ),
    );
  }

  Widget _buildFlowerStep(SurpriseProvider provider) {
    return Column(
      children: [
        const Text(
          'Selecciona una flor para la sorpresa:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: FlowerType.values.map((type) {
            return GestureDetector(
              onTap: () => setState(() => _selectedFlowerType = type),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedFlowerType == type
                        ? Colors.pink
                        : Colors.grey,
                    width: _selectedFlowerType == type ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(type.emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 4),
                    Text(
                      type.displayName,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        if (!provider.isPremium)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '💡 Mejora a Premium para agregar más características',
              style: TextStyle(color: Colors.blue),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewStep(SurpriseProvider provider) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                _SummaryRow('De:', _creatorNameCtrl.text),
                _SummaryRow('Para:', _recipientNameCtrl.text),
                _SummaryRow('Título:', _titleCtrl.text),
                _SummaryRow('Flor:', _selectedFlowerType.displayName),
                _SummaryRow(
                  'Fecha:',
                  _selectedDate != null
                      ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                      : 'No seleccionada',
                ),
              ],
            ),
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

  void _createSurprise(BuildContext context, SurpriseProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final surprise = await provider.createSurprise(
      userUid: widget.userId,
      userName: _creatorNameCtrl.text,
      recipientName: _recipientNameCtrl.text,
      personalMessage: _messageCtrl.text,
      flowerType: _selectedFlowerType.toString().split('.').last,
      flowerIds: ['1'],  // Single flower for free plan
      specialDate: _selectedDate ?? DateTime.now(),
    );

    if (mounted && surprise != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Sorpresa creada!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, surprise);
    }
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
