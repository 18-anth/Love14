enum SurpriseStatus { draft, published, viewed, expired }

enum PlanType { free, premium }

class SurpriseModel {
  final String surpriseId;
  final String creatorUid;
  final String creatorName;
  final String recipientName;
  final String personalMessage;
  final String flowerType; // Type of flower (rose, tulip, sunflower, etc.)
  final List<String> flowerIds; // IDs of 3D flowers
  final String? musicUrl; // Premium feature
  final List<String> photoUrls; // Premium: multiple photos
  final String? videoUrl; // Premium: video optional
  final DateTime specialDate; // Special occasion date
  final String? aiLetter; // Premium: AI-generated romantic letter
  final String? publicUrl; // Public shareable link
  final String? qrCode; // QR code data/image URL
  final SurpriseStatus status;
  final PlanType planType;
  final int viewCount;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final Map<String, dynamic>? metadata;

  SurpriseModel({
    required this.surpriseId,
    required this.creatorUid,
    required this.creatorName,
    required this.recipientName,
    required this.personalMessage,
    required this.flowerType,
    required this.flowerIds,
    this.musicUrl,
    required this.photoUrls,
    this.videoUrl,
    required this.specialDate,
    this.aiLetter,
    this.publicUrl,
    this.qrCode,
    required this.status,
    required this.planType,
    this.viewCount = 0,
    required this.createdAt,
    this.expiresAt,
    this.metadata,
  });

  /// Check if surprise is expired
  bool isExpired() {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Get remaining days until special date
  int daysUntilSpecialDate() {
    final difference = specialDate.difference(DateTime.now());
    return difference.inDays;
  }

  /// Check if user has premium features
  bool hasPremiumAccess() => planType == PlanType.premium;

  /// Validate free tier restrictions
  bool isValidForFreeTier() {
    // Free tier: 1 flower, 1 poem, link only
    return flowerIds.length <= 1 && photoUrls.length <= 1;
  }

  /// Get available features based on plan
  SurpriseFeatures getAvailableFeatures() {
    return SurpriseFeatures(
      music: planType == PlanType.premium,
      multipleFlowers: planType == PlanType.premium,
      photos: planType == PlanType.premium,
      video: planType == PlanType.premium,
      aiLetter: planType == PlanType.premium,
      qrCode: planType == PlanType.premium,
      publicLink: true, // Both tiers
    );
  }

  /// Convert to Firebase Document
  Map<String, dynamic> toMap() {
    return {
      'surpriseId': surpriseId,
      'creatorUid': creatorUid,
      'creatorName': creatorName,
      'recipientName': recipientName,
      'personalMessage': personalMessage,
      'flowerType': flowerType,
      'flowerIds': flowerIds,
      'musicUrl': musicUrl,
      'photoUrls': photoUrls,
      'videoUrl': videoUrl,
      'specialDate': specialDate.toIso8601String(),
      'aiLetter': aiLetter,
      'publicUrl': publicUrl,
      'qrCode': qrCode,
      'status': status.toString().split('.').last,
      'planType': planType.toString().split('.').last,
      'viewCount': viewCount,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create from Firebase Document
  factory SurpriseModel.fromMap(String docId, Map<String, dynamic> map) {
    return SurpriseModel(
      surpriseId: docId,
      creatorUid: map['creatorUid'] as String,
      creatorName: map['creatorName'] as String,
      recipientName: map['recipientName'] as String,
      personalMessage: map['personalMessage'] as String,
      flowerType: map['flowerType'] as String,
      flowerIds: List<String>.from(map['flowerIds'] as List? ?? []),
      musicUrl: map['musicUrl'] as String?,
      photoUrls: List<String>.from(map['photoUrls'] as List? ?? []),
      videoUrl: map['videoUrl'] as String?,
      specialDate: DateTime.parse(map['specialDate'] as String),
      aiLetter: map['aiLetter'] as String?,
      publicUrl: map['publicUrl'] as String?,
      qrCode: map['qrCode'] as String?,
      status: SurpriseStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => SurpriseStatus.draft,
      ),
      planType: PlanType.values.firstWhere(
        (e) => e.toString().split('.').last == map['planType'],
        orElse: () => PlanType.free,
      ),
      viewCount: (map['viewCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(map['createdAt'] as String),
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'] as String)
          : null,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Create copy with modifications
  SurpriseModel copyWith({
    String? surpriseId,
    String? creatorUid,
    String? creatorName,
    String? recipientName,
    String? personalMessage,
    String? flowerType,
    List<String>? flowerIds,
    String? musicUrl,
    List<String>? photoUrls,
    String? videoUrl,
    DateTime? specialDate,
    String? aiLetter,
    String? publicUrl,
    String? qrCode,
    SurpriseStatus? status,
    PlanType? planType,
    int? viewCount,
    DateTime? createdAt,
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
  }) {
    return SurpriseModel(
      surpriseId: surpriseId ?? this.surpriseId,
      creatorUid: creatorUid ?? this.creatorUid,
      creatorName: creatorName ?? this.creatorName,
      recipientName: recipientName ?? this.recipientName,
      personalMessage: personalMessage ?? this.personalMessage,
      flowerType: flowerType ?? this.flowerType,
      flowerIds: flowerIds ?? this.flowerIds,
      musicUrl: musicUrl ?? this.musicUrl,
      photoUrls: photoUrls ?? this.photoUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      specialDate: specialDate ?? this.specialDate,
      aiLetter: aiLetter ?? this.aiLetter,
      publicUrl: publicUrl ?? this.publicUrl,
      qrCode: qrCode ?? this.qrCode,
      status: status ?? this.status,
      planType: planType ?? this.planType,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'SurpriseModel(surpriseId: $surpriseId, recipientName: $recipientName, status: $status)';
  }
}

/// Represents available features for each plan tier
class SurpriseFeatures {
  final bool music;
  final bool multipleFlowers;
  final bool photos;
  final bool video;
  final bool aiLetter;
  final bool qrCode;
  final bool publicLink;

  SurpriseFeatures({
    required this.music,
    required this.multipleFlowers,
    required this.photos,
    required this.video,
    required this.aiLetter,
    required this.qrCode,
    required this.publicLink,
  });

  /// Get price for premium plan (in USD)
  static const double premiumPrice = 9.99;

  /// Free tier features
  factory SurpriseFeatures.free() {
    return SurpriseFeatures(
      music: false,
      multipleFlowers: false,
      photos: false,
      video: false,
      aiLetter: false,
      qrCode: false,
      publicLink: true,
    );
  }

  /// Premium tier features
  factory SurpriseFeatures.premium() {
    return SurpriseFeatures(
      music: true,
      multipleFlowers: true,
      photos: true,
      video: true,
      aiLetter: true,
      qrCode: true,
      publicLink: true,
    );
  }

  int countAvailableFeatures() {
    int count = 0;
    if (music) count++;
    if (multipleFlowers) count++;
    if (photos) count++;
    if (video) count++;
    if (aiLetter) count++;
    if (qrCode) count++;
    if (publicLink) count++;
    return count;
  }
}
