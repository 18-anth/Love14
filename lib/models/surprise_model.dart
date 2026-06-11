import 'package:love14/models/flower_model.dart';

enum SurpriseStatus { draft, published, viewed, shared, archived }

// Type alias for compatibility
typedef SurpriseModel = Surprise;

class Surprise {
  final String surpriseId;
  final String creatorId; // User who created it
  final String recipientName; // Nome de quem recebe
  final String creatorName; // Nome de quem envia
  final String title; // "A sorpresa para María"
  final String description; // Descrição
  final String? customMessage; // Mensagem personalizada
  final Flower flower; // Flores selecionadas
  final List<String> photoUrls; // URLs de fotos (premium)
  final String? videoUrl; // URL de vídeo (premium)
  final String? musicUrl; // URL de música (premium)
  final String? aiLetter; // Carta gerada por IA (premium)
  final DateTime specialDate; // Data especial (aniversário, etc)
  final String publicUrl; // URL pública da sorpresa
  final String qrCode; // Código QR codificado como string
  final SurpriseStatus status;
  final DateTime createdAt;
  final DateTime? viewedAt;
  final DateTime? expiresAt;
  final Map<String, int>? analytics; // {views: 10, shares: 2}
  final int? premium; // 1 = premium, 0 = free
  final bool isPremium; // deprecated: use premium field

  Surprise({
    required this.surpriseId,
    required this.creatorId,
    required this.recipientName,
    required this.creatorName,
    required this.title,
    required this.description,
    this.customMessage,
    required this.flower,
    this.photoUrls = const [],
    this.videoUrl,
    this.musicUrl,
    this.aiLetter,
    required this.specialDate,
    required this.publicUrl,
    required this.qrCode,
    required this.status,
    required this.createdAt,
    this.viewedAt,
    this.expiresAt,
    this.analytics,
    this.premium,
    this.isPremium = false,
  });

  bool isExpired() {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool isViewed() => viewedAt != null;

  int getViewCount() => analytics?['views'] ?? 0;

  int getShareCount() => analytics?['shares'] ?? 0;

  bool hasPremiumFeatures() {
    return (premium == 1) ||
        isPremium ||
        photoUrls.isNotEmpty ||
        videoUrl != null ||
        musicUrl != null ||
        aiLetter != null;
  }

  Map<String, dynamic> toMap() {
    return {
      'surpriseId': surpriseId,
      'creatorId': creatorId,
      'recipientName': recipientName,
      'creatorName': creatorName,
      'title': title,
      'description': description,
      'customMessage': customMessage,
      'flower': flower.toMap(),
      'photoUrls': photoUrls,
      'videoUrl': videoUrl,
      'musicUrl': musicUrl,
      'aiLetter': aiLetter,
      'specialDate': specialDate.toIso8601String(),
      'publicUrl': publicUrl,
      'qrCode': qrCode,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'viewedAt': viewedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'analytics': analytics,
      'premium': premium ?? (isPremium ? 1 : 0),
    };
  }

  factory Surprise.fromMap(String docId, Map<String, dynamic> map) {
    return Surprise(
      surpriseId: docId,
      creatorId: map['creatorId'] as String,
      recipientName: map['recipientName'] as String,
      creatorName: map['creatorName'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      customMessage: map['customMessage'] as String?,
      flower: Flower.fromMap(map['flower'] ?? {}),
      photoUrls: List<String>.from(map['photoUrls'] as List? ?? []),
      videoUrl: map['videoUrl'] as String?,
      musicUrl: map['musicUrl'] as String?,
      aiLetter: map['aiLetter'] as String?,
      specialDate: DateTime.parse(map['specialDate'] as String),
      publicUrl: map['publicUrl'] as String,
      qrCode: map['qrCode'] as String,
      status: SurpriseStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => SurpriseStatus.draft,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      viewedAt: map['viewedAt'] != null
          ? DateTime.parse(map['viewedAt'])
          : null,
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'])
          : null,
      analytics: map['analytics'] != null
          ? Map<String, int>.from(map['analytics'])
          : null,
      premium: map['premium'] as int?,
      isPremium: (map['premium'] as int? ?? 0) == 1,
    );
  }

  Surprise copyWith({
    String? surpriseId,
    String? creatorId,
    String? recipientName,
    String? creatorName,
    String? title,
    String? description,
    String? customMessage,
    Flower? flower,
    List<String>? photoUrls,
    String? videoUrl,
    String? musicUrl,
    String? aiLetter,
    DateTime? specialDate,
    String? publicUrl,
    String? qrCode,
    SurpriseStatus? status,
    DateTime? createdAt,
    DateTime? viewedAt,
    DateTime? expiresAt,
    Map<String, int>? analytics,
    int? premium,
    bool? isPremium,
  }) {
    return Surprise(
      surpriseId: surpriseId ?? this.surpriseId,
      creatorId: creatorId ?? this.creatorId,
      recipientName: recipientName ?? this.recipientName,
      creatorName: creatorName ?? this.creatorName,
      title: title ?? this.title,
      description: description ?? this.description,
      customMessage: customMessage ?? this.customMessage,
      flower: flower ?? this.flower,
      photoUrls: photoUrls ?? this.photoUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      musicUrl: musicUrl ?? this.musicUrl,
      aiLetter: aiLetter ?? this.aiLetter,
      specialDate: specialDate ?? this.specialDate,
      publicUrl: publicUrl ?? this.publicUrl,
      qrCode: qrCode ?? this.qrCode,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      viewedAt: viewedAt ?? this.viewedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      analytics: analytics ?? this.analytics,
      premium: premium ?? this.premium,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
