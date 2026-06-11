import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data';
import 'package:love14/Features/Surprises/Domain/models/surprise_model.dart';
import 'package:love14/Features/Surprises/Domain/models/flower_model.dart';
import 'package:love14/Features/Surprises/Domain/models/freemium_model.dart';
// Add required imports at top of file:
import 'dart:io';
import 'dart:convert';
import 'dart:ui' show ImageByteFormat, Color;

class SurpriseService {
  static final SurpriseService _instance = SurpriseService._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  late final CollectionReference<Map<String, dynamic>> _surprisesCollection;
  late final CollectionReference<Map<String, dynamic>> _usersPlansCollection;

  SurpriseService._internal();

  factory SurpriseService() {
    return _instance;
  }

  void initialize() {
    _surprisesCollection = _firestore.collection('surprises');
    _usersPlansCollection = _firestore.collection('user_plans');
  }

  // ============ SURPRISE CRUD OPERATIONS ============

  /// Create a new surprise (draft)
  Future<Surprise> createSurprise({
    required String creatorId,
    required String recipientName,
    required String creatorName,
    required String title,
    required String description,
    String? customMessage,
    required Flower flower,
    required DateTime specialDate,
    bool isPremium = false,
  }) async {
    try {
      final surpriseId = const Uuid().v4();
      final publicUrl = 'https://love14.app/surprise/$surpriseId';

      final surprise = Surprise(
        surpriseId: surpriseId,
        creatorId: creatorId,
        recipientName: recipientName,
        creatorName: creatorName,
        title: title,
        description: description,
        customMessage: customMessage,
        flower: flower,
        specialDate: specialDate,
        publicUrl: publicUrl,
        qrCode: await _generateQRCode(publicUrl),
        status: SurpriseStatus.draft,
        createdAt: DateTime.now(),
        premium: isPremium ? 1 : 0,
        isPremium: isPremium,
      );

      await _surprisesCollection.doc(surpriseId).set(surprise.toMap());
      return surprise;
    } catch (e) {
      throw Exception('Failed to create surprise: $e');
    }
  }

  /// Get surprise by ID
  Future<Surprise?> getSurprise(String surpriseId) async {
    try {
      final doc = await _surprisesCollection.doc(surpriseId).get();
      if (!doc.exists) return null;
      return Surprise.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get surprise: $e');
    }
  }

  /// Get user's surprises
  Future<List<Surprise>> getUserSurprises(String creatorId) async {
    try {
      final query = await _surprisesCollection
          .where('creatorId', isEqualTo: creatorId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Surprise.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user surprises: $e');
    }
  }

  /// Update surprise
  Future<void> updateSurprise(
    String surpriseId,
    Map<String, dynamic> data,
  ) async {
    try {
      data['updatedAt'] = DateTime.now().toIso8601String();
      await _surprisesCollection.doc(surpriseId).update(data);
    } catch (e) {
      throw Exception('Failed to update surprise: $e');
    }
  }

  /// Publish surprise (make it public)
  Future<void> publishSurprise(String surpriseId) async {
    try {
      await _surprisesCollection.doc(surpriseId).update({
        'status': 'published',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to publish surprise: $e');
    }
  }

  /// Mark as viewed
  Future<void> markAsViewed(String surpriseId) async {
    try {
      await _surprisesCollection.doc(surpriseId).update({
        'viewedAt': DateTime.now().toIso8601String(),
        'status': 'viewed',
        'analytics.views': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to mark as viewed: $e');
    }
  }

  /// Track share event
  Future<void> trackShare(String surpriseId) async {
    try {
      await _surprisesCollection.doc(surpriseId).update({
        'analytics.shares': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to track share: $e');
    }
  }

  /// Delete surprise
  Future<void> deleteSurprise(String surpriseId) async {
    try {
      await _surprisesCollection.doc(surpriseId).delete();
    } catch (e) {
      throw Exception('Failed to delete surprise: $e');
    }
  }

  // ============ MEDIA UPLOAD ============

  /// Upload photos to Firebase Storage
  Future<String> uploadPhoto(
    String surpriseId,
    Uint8List imageBytes,
    int index,
  ) async {
    try {
      final fileName = 'surprises/$surpriseId/photo_$index.jpg';
      final ref = _storage.ref(fileName);
      final uploadTask = ref.putData(imageBytes);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  /// Upload video to Firebase Storage
  Future<String> uploadVideo(String surpriseId, String filePath) async {
    try {
      final fileName = 'surprises/$surpriseId/video.mp4';
      final ref = _storage.ref(fileName);
      final uploadTask = ref.putFile(await _getFileFromPath(filePath));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  /// Upload audio/music to Firebase Storage
  Future<String> uploadMusic(String surpriseId, String filePath) async {
    try {
      final fileName = 'surprises/$surpriseId/music.mp3';
      final ref = _storage.ref(fileName);
      final uploadTask = ref.putFile(await _getFileFromPath(filePath));
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload music: $e');
    }
  }

  // ============ FREEMIUM PLAN ============

  /// Get user's current plan
  Future<FreemiumPlan> getUserPlan(String userId) async {
    try {
      final doc = await _usersPlansCollection.doc(userId).get();

      if (!doc.exists) {
        // Create default free plan
        final freePlan = FreemiumPlan.createFreePlan();
        await _usersPlansCollection.doc(userId).set(freePlan.toMap());
        return freePlan;
      }

      return FreemiumPlan.fromMap(doc.data()!);
    } catch (e) {
      throw Exception('Failed to get user plan: $e');
    }
  }

  /// Upgrade user to premium
  Future<void> upgradeToPremium(
    String userId, {
    int monthsDuration = 12,
  }) async {
    try {
      final premiumPlan = FreemiumPlan.createPremiumPlan();
      final updatedPlan = premiumPlan.copyWith(
        expiresAt: DateTime.now().add(Duration(days: 30 * monthsDuration)),
      );

      await _usersPlansCollection.doc(userId).set(updatedPlan.toMap());
    } catch (e) {
      throw Exception('Failed to upgrade to premium: $e');
    }
  }

  /// Check if user can create surprise
  Future<bool> canCreateSurprise(String userId) async {
    try {
      final plan = await getUserPlan(userId);
      return plan.canCreateSurprise();
    } catch (e) {
      throw Exception('Failed to check if can create surprise: $e');
    }
  }

  /// Increment surprise count
  Future<void> incrementSurpriseCount(String userId) async {
    try {
      await _usersPlansCollection.doc(userId).update({
        'surprisesCreated': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to increment surprise count: $e');
    }
  }

  /// Check if feature is available for user
  Future<bool> hasFeature(String userId, PlanFeature feature) async {
    try {
      final plan = await getUserPlan(userId);
      return plan.hasFeature(feature);
    } catch (e) {
      throw Exception('Failed to check feature: $e');
    }
  }

  // ============ HELPER METHODS ============

  /// Generate QR Code as image (base64 encoded)
  Future<String> _generateQRCode(String data) async {
    try {
      final qrImage = await QrPainter(
        data: data,
        version: QrVersions.auto,
        emptyColor: const Color.fromARGB(255, 255, 255, 255),
        color: const Color.fromARGB(255, 0, 0, 0),
      ).toImage(200);

      final byteData = await qrImage.toByteData(format: ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();
      return base64Encode(bytes);
    } catch (e) {
      throw Exception('Failed to generate QR code: $e');
    }
  }

  /// Get file from file path (for uploads)
  Future<File> _getFileFromPath(String filePath) async {
    return File(filePath);
  }
}
