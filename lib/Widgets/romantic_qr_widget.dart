import 'package:flutter/material.dart';
import 'package:love14/Utils/app_colors.dart';

class RomanticQRWidget extends StatelessWidget {
  final String data;
  final String? title;
  final String? subtitle;
  final double size;
  final VoidCallback? onSave;

  const RomanticQRWidget({
    super.key,
    required this.data,
    this.title,
    this.subtitle,
    this.size = 200,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryPink),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
          ],
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primaryPink),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.primaryPink),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Text('QR Code')),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Escanea con tu teléfono para ver esta sorpresa 📱',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (onSave != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.download),
              label: const Text('Descargar QR'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPink,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RomanticQRDialog extends StatelessWidget {
  final String data;
  final String title;
  final VoidCallback? onSave;

  const RomanticQRDialog({
    super.key,
    required this.data,
    required this.title,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: RomanticQRWidget(
        data: data,
        title: title,
        subtitle: 'Comparte este código QR',
        size: 180,
        onSave: onSave,
      ),
    );
  }
}
