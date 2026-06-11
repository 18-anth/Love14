import 'package:flutter/material.dart';
import 'package:love14/Features/Surprises/Domain/models/flower_model.dart';

class FlowerSelector extends StatelessWidget {
  final Flower selectedFlower;
  final Function(Flower) onFlowerSelected;
  final bool enableMultiple;

  const FlowerSelector({
    super.key,
    required this.selectedFlower,
    required this.onFlowerSelected,
    this.enableMultiple = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona la flor',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: FlowerType.values.map((flowerType) {
            final flower = Flower(type: flowerType);
            final isSelected = selectedFlower.type == flowerType;

            return GestureDetector(
              onTap: () => onFlowerSelected(flower),
              child: Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.pink.shade50 : Colors.grey.shade50,
                  border: Border.all(
                    color: isSelected ? Colors.pink : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      flower.type.emoji,
                      style: const TextStyle(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      flower.type.displayName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.pink : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FlowerPreview extends StatelessWidget {
  final Flower flower;
  final double size;

  const FlowerPreview({
    super.key,
    required this.flower,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.pink.shade50,
        border: Border.all(
          color: Colors.pink.shade200,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          flower.type.emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}

class FlowerCard extends StatelessWidget {
  final Flower flower;
  final VoidCallback? onTap;
  final bool showDeleteButton;
  final VoidCallback? onDelete;

  const FlowerCard({
    super.key,
    required this.flower,
    this.onTap,
    this.showDeleteButton = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flower.type.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showDeleteButton)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onDelete,
                    color: Colors.red,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              flower.type.emoji,
              style: const TextStyle(fontSize: 48),
            ),
            if (flower.quantity > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Cantidad: ${flower.quantity}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
