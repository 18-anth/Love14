class Couple {
  final String coupleId;
  final List<String> userIds; // [user1_uid, user2_uid]
  final String? coupleName; // "John & Maria"
  final DateTime? anniversaryDate;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Couple({
    required this.coupleId,
    required this.userIds,
    this.coupleName,
    this.anniversaryDate,
    required this.createdAt,
    this.updatedAt,
  });

  // Validate couple has exactly 2 users
  bool isValid() => userIds.length == 2;

  // Convert to Firebase Document
  Map<String, dynamic> toMap() {
    return {
      'coupleId': coupleId,
      'userIds': userIds,
      'coupleName': coupleName,
      'anniversaryDate': anniversaryDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create from Firebase Document
  factory Couple.fromMap(String docId, Map<String, dynamic> map) {
    return Couple(
      coupleId: docId,
      userIds: List<String>.from(map['userIds'] as List),
      coupleName: map['coupleName'] as String?,
      anniversaryDate: map['anniversaryDate'] != null
          ? DateTime.parse(map['anniversaryDate'] as String)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'] as String)
          : null,
    );
  }

  // Create copy with modifications
  Couple copyWith({
    String? coupleId,
    List<String>? userIds,
    String? coupleName,
    DateTime? anniversaryDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Couple(
      coupleId: coupleId ?? this.coupleId,
      userIds: userIds ?? this.userIds,
      coupleName: coupleName ?? this.coupleName,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
