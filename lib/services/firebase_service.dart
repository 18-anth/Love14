import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:love14/models/couple_model.dart';
import 'package:love14/models/gift_model.dart';
import 'package:love14/models/payment_model.dart';
import 'package:love14/models/user_model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  late final CollectionReference<Map<String, dynamic>> _usersCollection;
  late final CollectionReference<Map<String, dynamic>> _couplesCollection;
  late final CollectionReference<Map<String, dynamic>> _giftsCollection;
  late final CollectionReference<Map<String, dynamic>> _paymentsCollection;

  FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  // Initialize collections
  void initialize() {
    _usersCollection = _firestore.collection('users');
    _couplesCollection = _firestore.collection('couples');
    _giftsCollection = _firestore.collection('gifts');
    _paymentsCollection = _firestore.collection('payments');
  }

  // ============ USER OPERATIONS ============

  /// Create a new user in Firestore
  Future<void> createUser(User user) async {
    try {
      await _usersCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  /// Get user by UID
  Future<User?> getUser(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (!doc.exists) return null;
      return User.fromMap(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Update user
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();
      await _usersCollection.doc(uid).update(data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // ============ COUPLE OPERATIONS ============

  /// Create a new couple
  Future<String> createCouple(Couple couple) async {
    try {
      final docRef = await _couplesCollection.add(couple.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create couple: $e');
    }
  }

  /// Get couple by ID
  Future<Couple?> getCouple(String coupleId) async {
    try {
      final doc = await _couplesCollection.doc(coupleId).get();
      if (!doc.exists) return null;
      return Couple.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get couple: $e');
    }
  }

  /// Get couple by user ID (user is part of couple)
  Future<Couple?> getCoupleByUserId(String userId) async {
    try {
      final querySnapshot = await _couplesCollection
          .where('userIds', arrayContains: userId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;
      final doc = querySnapshot.docs.first;
      return Couple.fromMap(doc.id, doc.data());
    } catch (e) {
      throw Exception('Failed to get couple by user: $e');
    }
  }

  /// Update couple
  Future<void> updateCouple(String coupleId, Map<String, dynamic> data) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();
      await _couplesCollection.doc(coupleId).update(data);
    } catch (e) {
      throw Exception('Failed to update couple: $e');
    }
  }

  // ============ GIFT OPERATIONS ============

  /// Create a new gift (draft)
  Future<String> createGift(Gift gift) async {
    try {
      final docRef = await _giftsCollection.add(gift.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create gift: $e');
    }
  }

  /// Get gift by ID
  Future<Gift?> getGift(String giftId) async {
    try {
      final doc = await _giftsCollection.doc(giftId).get();
      if (!doc.exists) return null;
      return Gift.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get gift: $e');
    }
  }

  /// Get gifts for a couple
  Future<List<Gift>> getGiftsByCouple(String coupleId) async {
    try {
      final querySnapshot = await _giftsCollection
          .where('coupleId', isEqualTo: coupleId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Gift.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get gifts: $e');
    }
  }

  /// Get gifts sent by a user
  Future<List<Gift>> getGiftsSentByUser(String userId) async {
    try {
      final querySnapshot = await _giftsCollection
          .where('senderId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Gift.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get sent gifts: $e');
    }
  }

  /// Get gifts received by a user
  Future<List<Gift>> getGiftsReceivedByUser(String userId) async {
    try {
      final querySnapshot = await _giftsCollection
          .where('recipientId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Gift.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get received gifts: $e');
    }
  }

  /// Update gift (typically to mark as sent/viewed/opened)
  Future<void> updateGift(String giftId, Map<String, dynamic> data) async {
    try {
      await _giftsCollection.doc(giftId).update(data);
    } catch (e) {
      throw Exception('Failed to update gift: $e');
    }
  }

  /// Mark gift as sent
  Future<void> markGiftAsSent(String giftId) async {
    try {
      await _giftsCollection.doc(giftId).update({
        'status': 'sent',
        'sentAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to mark gift as sent: $e');
    }
  }

  /// Mark gift as viewed
  Future<void> markGiftAsViewed(String giftId) async {
    try {
      await _giftsCollection.doc(giftId).update({
        'status': 'viewed',
        'viewedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to mark gift as viewed: $e');
    }
  }

  // ============ PAYMENT OPERATIONS ============

  /// Create a new payment record
  Future<String> createPayment(Payment payment) async {
    try {
      final docRef = await _paymentsCollection.add(payment.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  /// Get payment by ID
  Future<Payment?> getPayment(String paymentId) async {
    try {
      final doc = await _paymentsCollection.doc(paymentId).get();
      if (!doc.exists) return null;
      return Payment.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get payment: $e');
    }
  }

  /// Get payments for a gift
  Future<List<Payment>> getPaymentsByGift(String giftId) async {
    try {
      final querySnapshot = await _paymentsCollection
          .where('giftId', isEqualTo: giftId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Payment.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get payments: $e');
    }
  }

  /// Update payment status (when Stripe confirms)
  Future<void> updatePaymentStatus(
    String paymentId,
    PaymentStatus status,
    String? stripeChargeId,
  ) async {
    try {
      await _paymentsCollection.doc(paymentId).update({
        'status': status.toString().split('.').last,
        'stripeChargeId': stripeChargeId,
        'completedAt': status == PaymentStatus.completed
            ? DateTime.now().toIso8601String()
            : null,
      });
    } catch (e) {
      throw Exception('Failed to update payment: $e');
    }
  }

  // ============ SECURITY RULES ============

  /// Get Firestore security rules (for reference)
  static String getSecurityRules() {
    return '''
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own document
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }

    // Couples - users can read/write only if they're part of the couple
    match /couples/{coupleId} {
      allow read, write: if 
        request.auth.uid in resource.data.userIds;
      
      // Create new couple
      allow create: if request.auth.uid != null;
    }

    // Gifts - users can read if they're sender or recipient
    match /gifts/{giftId} {
      allow read: if 
        request.auth.uid == resource.data.senderId ||
        request.auth.uid == resource.data.recipientId;
      
      allow write: if request.auth.uid == resource.data.senderId;
      
      // Create gift
      allow create: if request.auth.uid != null;
    }

    // Payments - users can only read/write their own payments
    match /payments/{paymentId} {
      allow read, write: if request.auth.uid == resource.data.userId;
      
      allow create: if request.auth.uid != null;
    }
  }
}
    ''';
  }
}
