enum FlowerType {
  rosa,
  girasol,
  tulipan,
  margarita,
  clavel,
  lirio,
  orquidea,
  amapola,
  loto,
  sakura,
}

extension FlowerTypeExt on FlowerType {
  String get displayName {
    switch (this) {
      case FlowerType.rosa:
        return 'Rosa';
      case FlowerType.girasol:
        return 'Girasol';
      case FlowerType.tulipan:
        return 'Tulipán';
      case FlowerType.margarita:
        return 'Margarita';
      case FlowerType.clavel:
        return 'Clavel';
      case FlowerType.lirio:
        return 'Lirio';
      case FlowerType.orquidea:
        return 'Orquídea';
      case FlowerType.amapola:
        return 'Amapola';
      case FlowerType.loto:
        return 'Loto';
      case FlowerType.sakura:
        return 'Sakura';
    }
  }

  String get emoji {
    switch (this) {
      case FlowerType.rosa:
        return '🌹';
      case FlowerType.girasol:
        return '🌻';
      case FlowerType.tulipan:
        return '🌷';
      case FlowerType.margarita:
        return '🌼';
      case FlowerType.clavel:
        return '💐';
      case FlowerType.lirio:
        return '🪷';
      case FlowerType.orquidea:
        return '🪻';
      case FlowerType.amapola:
        return '🌺';
      case FlowerType.loto:
        return '🪷';
      case FlowerType.sakura:
        return '🌸';
    }
  }

  String get assetPath {
    switch (this) {
      case FlowerType.rosa:
        return 'assets/flowers/rosa.glb';
      case FlowerType.girasol:
        return 'assets/flowers/girasol.glb';
      case FlowerType.tulipan:
        return 'assets/flowers/tulipan.glb';
      case FlowerType.margarita:
        return 'assets/flowers/margarita.glb';
      case FlowerType.clavel:
        return 'assets/flowers/clavel.glb';
      case FlowerType.lirio:
        return 'assets/flowers/lirio.glb';
      case FlowerType.orquidea:
        return 'assets/flowers/orquidea.glb';
      case FlowerType.amapola:
        return 'assets/flowers/amapola.glb';
      case FlowerType.loto:
        return 'assets/flowers/loto.glb';
      case FlowerType.sakura:
        return 'assets/flowers/sakura.glb';
    }
  }
}

class Flower {
  final FlowerType type;
  final String? color;
  final int quantity; // Número de flores (solo premium)
  final DateTime addedAt;

  Flower({
    required this.type,
    this.color,
    this.quantity = 1,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'type': type.toString().split('.').last,
      'color': color,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory Flower.fromMap(Map<String, dynamic> map) {
    return Flower(
      type: FlowerType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => FlowerType.rosa,
      ),
      color: map['color'],
      quantity: map['quantity'] ?? 1,
      addedAt: DateTime.parse(map['addedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Flower copyWith({
    FlowerType? type,
    String? color,
    int? quantity,
    DateTime? addedAt,
  }) {
    return Flower(
      type: type ?? this.type,
      color: color ?? this.color,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
