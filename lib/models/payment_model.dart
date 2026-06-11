enum PaymentStatus { pending, completed, failed, refunded }

class Payment {
  final String paymentId;
  final String giftId;
  final String userId; // Who paid
  final String coupleId;
  final double amount; // USD
  final String currency; // 'USD'
  final PaymentStatus status;
  final String? stripePaymentIntentId;
  final String? stripeChargeId;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;

  Payment({
    required this.paymentId,
    required this.giftId,
    required this.userId,
    required this.coupleId,
    required this.amount,
    required this.currency,
    required this.status,
    this.stripePaymentIntentId,
    this.stripeChargeId,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
  });

  // Convert to Firebase Document
  Map<String, dynamic> toMap() {
    return {
      'paymentId': paymentId,
      'giftId': giftId,
      'userId': userId,
      'coupleId': coupleId,
      'amount': amount,
      'currency': currency,
      'status': status.toString().split('.').last,
      'stripePaymentIntentId': stripePaymentIntentId,
      'stripeChargeId': stripeChargeId,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'failureReason': failureReason,
    };
  }

  // Create from Firebase Document
  factory Payment.fromMap(String docId, Map<String, dynamic> map) {
    return Payment(
      paymentId: docId,
      giftId: map['giftId'] as String,
      userId: map['userId'] as String,
      coupleId: map['coupleId'] as String,
      amount: (map['amount'] as num).toDouble(),
      currency: map['currency'] as String,
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => PaymentStatus.pending,
      ),
      stripePaymentIntentId: map['stripePaymentIntentId'] as String?,
      stripeChargeId: map['stripeChargeId'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'] as String)
          : null,
      failureReason: map['failureReason'] as String?,
    );
  }

  // Create copy with modifications
  Payment copyWith({
    String? paymentId,
    String? giftId,
    String? userId,
    String? coupleId,
    double? amount,
    String? currency,
    PaymentStatus? status,
    String? stripePaymentIntentId,
    String? stripeChargeId,
    DateTime? createdAt,
    DateTime? completedAt,
    String? failureReason,
  }) {
    return Payment(
      paymentId: paymentId ?? this.paymentId,
      giftId: giftId ?? this.giftId,
      userId: userId ?? this.userId,
      coupleId: coupleId ?? this.coupleId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      stripePaymentIntentId: stripePaymentIntentId ?? this.stripePaymentIntentId,
      stripeChargeId: stripeChargeId ?? this.stripeChargeId,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      failureReason: failureReason ?? this.failureReason,
    );
  }
}
