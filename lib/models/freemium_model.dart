enum UserPlan { free, premium }

// Type alias for compatibility with provider
typedef PlanType = UserPlan;

enum PlanFeature {
  multipleFlowers,
  customMusic,
  photos,
  videos,
  aiLetter,
  customQR,
  analytics,
  customExpiration,
  teamAccess,
}

extension PlanFeatureExt on PlanFeature {
  String get displayName {
    switch (this) {
      case PlanFeature.multipleFlowers:
        return 'Múltiples flores';
      case PlanFeature.customMusic:
        return 'Música personalizada';
      case PlanFeature.photos:
        return 'Fotos';
      case PlanFeature.videos:
        return 'Videos';
      case PlanFeature.aiLetter:
        return 'Carta con IA';
      case PlanFeature.customQR:
        return 'QR personalizado';
      case PlanFeature.analytics:
        return 'Analíticas avanzadas';
      case PlanFeature.customExpiration:
        return 'Expiración personalizada';
      case PlanFeature.teamAccess:
        return 'Acceso en equipo';
    }
  }

  bool isAvailableInPlan(UserPlan plan) {
    if (plan == UserPlan.premium) return true;

    switch (this) {
      case PlanFeature.multipleFlowers:
      case PlanFeature.customMusic:
      case PlanFeature.photos:
      case PlanFeature.videos:
      case PlanFeature.aiLetter:
      case PlanFeature.customQR:
      case PlanFeature.analytics:
      case PlanFeature.customExpiration:
      case PlanFeature.teamAccess:
        return false;
    }
  }
}

class FreemiumPlan {
  final UserPlan plan;
  final DateTime createdAt;
  final DateTime? upgradeDate;
  final DateTime? expiresAt;
  final int surprisesCreated;
  final int surprisesLimit;
  final List<PlanFeature> features;
  final double? monthlyPrice;

  FreemiumPlan({
    required this.plan,
    required this.createdAt,
    this.upgradeDate,
    this.expiresAt,
    required this.surprisesCreated,
    required this.surprisesLimit,
    required this.features,
    this.monthlyPrice,
  });

  bool canCreateSurprise() => surprisesCreated < surprisesLimit;

  bool hasFeature(PlanFeature feature) => features.contains(feature);

  bool isPremium() => plan == UserPlan.premium;

  bool isExpired() {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  static FreemiumPlan createFreePlan() {
    return FreemiumPlan(
      plan: UserPlan.free,
      createdAt: DateTime.now(),
      surprisesCreated: 0,
      surprisesLimit: 1,
      features: [],
      monthlyPrice: 0,
    );
  }

  static FreemiumPlan createPremiumPlan() {
    return FreemiumPlan(
      plan: UserPlan.premium,
      createdAt: DateTime.now(),
      upgradeDate: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 365)),
      surprisesCreated: 0,
      surprisesLimit: 999,
      features: [
        PlanFeature.multipleFlowers,
        PlanFeature.customMusic,
        PlanFeature.photos,
        PlanFeature.videos,
        PlanFeature.aiLetter,
        PlanFeature.customQR,
        PlanFeature.analytics,
        PlanFeature.customExpiration,
      ],
      monthlyPrice: 9.99,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'plan': plan.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'upgradeDate': upgradeDate?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'surprisesCreated': surprisesCreated,
      'surprisesLimit': surprisesLimit,
      'features': features.map((f) => f.toString().split('.').last).toList(),
      'monthlyPrice': monthlyPrice,
    };
  }

  factory FreemiumPlan.fromMap(Map<String, dynamic> map) {
    return FreemiumPlan(
      plan: UserPlan.values.firstWhere(
        (e) => e.toString().split('.').last == map['plan'],
        orElse: () => UserPlan.free,
      ),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      upgradeDate: map['upgradeDate'] != null ? DateTime.parse(map['upgradeDate']) : null,
      expiresAt: map['expiresAt'] != null ? DateTime.parse(map['expiresAt']) : null,
      surprisesCreated: map['surprisesCreated'] ?? 0,
      surprisesLimit: map['surprisesLimit'] ?? 1,
      features: (map['features'] as List?)
              ?.map((f) => PlanFeature.values.firstWhere(
                    (e) => e.toString().split('.').last == f,
                    orElse: () => PlanFeature.multipleFlowers,
                  ))
              .toList() ??
          [],
      monthlyPrice: (map['monthlyPrice'] as num?)?.toDouble(),
    );
  }

  FreemiumPlan copyWith({
    UserPlan? plan,
    DateTime? createdAt,
    DateTime? upgradeDate,
    DateTime? expiresAt,
    int? surprisesCreated,
    int? surprisesLimit,
    List<PlanFeature>? features,
    double? monthlyPrice,
  }) {
    return FreemiumPlan(
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
      upgradeDate: upgradeDate ?? this.upgradeDate,
      expiresAt: expiresAt ?? this.expiresAt,
      surprisesCreated: surprisesCreated ?? this.surprisesCreated,
      surprisesLimit: surprisesLimit ?? this.surprisesLimit,
      features: features ?? this.features,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
    );
  }
}
