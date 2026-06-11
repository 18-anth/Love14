enum GiftStatus { draft, sent, viewed, opened }

class Gift {
  final String giftId;
  final String senderId; // User who created the gift
  final String recipientId; // User receiving the gift
  final String coupleId; // Reference to couple
  final String poemId; // ID of poem selected
  final String poemText; // Full poem text
  final String? musicUrl; // Optional background music
  final String? voiceMessageUrl; // Optional voice message
  final String? customMessage; // Optional custom text
  final double amount; // Price paid (USD)
  final GiftStatus status; // draft, sent, viewed, opened
  final DateTime createdAt;
  final DateTime? sentAt;
  final DateTime? viewedAt;
  final DateTime? expiresAt; // When gift link expires
  final Map<String, dynamic>? metadata; // Extra data

  Gift({
    required this.giftId,
    required this.senderId,
    required this.recipientId,
    required this.coupleId,
    required this.poemId,
    required this.poemText,
    this.musicUrl,
    this.voiceMessageUrl,
    this.customMessage,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.sentAt,
    this.viewedAt,
    this.expiresAt,
    this.metadata,
  });

  // Check if gift is expired
  bool isExpired() {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  // Convert to Firebase Document
  Map<String, dynamic> toMap() {
    return {
      'giftId': giftId,
      'senderId': senderId,
      'recipientId': recipientId,
      'coupleId': coupleId,
      'poemId': poemId,
      'poemText': poemText,
      'musicUrl': musicUrl,
      'voiceMessageUrl': voiceMessageUrl,
      'customMessage': customMessage,
      'amount': amount,
      'status': status.toString().split('.').last, // enum to string
      'createdAt': createdAt.toIso8601String(),
      'sentAt': sentAt?.toIso8601String(),
      'viewedAt': viewedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  // Create from Firebase Document
  factory Gift.fromMap(String docId, Map<String, dynamic> map) {
    return Gift(
      giftId: docId,
      senderId: map['senderId'] as String,
      recipientId: map['recipientId'] as String,
      coupleId: map['coupleId'] as String,
      poemId: map['poemId'] as String,
      poemText: map['poemText'] as String,
      musicUrl: map['musicUrl'] as String?,
      voiceMessageUrl: map['voiceMessageUrl'] as String?,
      customMessage: map['customMessage'] as String?,
      amount: (map['amount'] as num).toDouble(),
      status: GiftStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => GiftStatus.draft,
      ),
      createdAt: DateTime.parse(map['createdAt'] as String),
      sentAt: map['sentAt'] != null
          ? DateTime.parse(map['sentAt'] as String)
          : null,
      viewedAt: map['viewedAt'] != null
          ? DateTime.parse(map['viewedAt'] as String)
          : null,
      expiresAt: map['expiresAt'] != null
          ? DateTime.parse(map['expiresAt'] as String)
          : null,
      metadata: map['metadata'] as Map<String, dynamic>?,
    );
  }

  // Create copy with modifications
  Gift copyWith({
    String? giftId,
    String? senderId,
    String? recipientId,
    String? coupleId,
    String? poemId,
    String? poemText,
    String? musicUrl,
    String? voiceMessageUrl,
    String? customMessage,
    double? amount,
    GiftStatus? status,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? viewedAt,
    DateTime? expiresAt,
    Map<String, dynamic>? metadata,
  }) {
    return Gift(
      giftId: giftId ?? this.giftId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      coupleId: coupleId ?? this.coupleId,
      poemId: poemId ?? this.poemId,
      poemText: poemText ?? this.poemText,
      musicUrl: musicUrl ?? this.musicUrl,
      voiceMessageUrl: voiceMessageUrl ?? this.voiceMessageUrl,
      customMessage: customMessage ?? this.customMessage,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      viewedAt: viewedAt ?? this.viewedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      metadata: metadata ?? this.metadata,
    );
  }
}
