import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:love14/models/flower_model.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:love14/models/freemium_model.dart';
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

  /// Create a new surprise with full details
  Future<Surprise> createSurprise({
    required String creatorUid,
    required String creatorName,
    required String recipientName,
    required String personalMessage,
    required String flowerType,
    required List<String> flowerIds,
    required DateTime specialDate,
    required PlanType planType,
    String? musicUrl,
    List<String>? photoUrls,
    String? videoUrl,
    String? aiLetter,
  }) async {
    try {
      final surpriseId = const Uuid().v4();
      final publicUrl = 'https://love14.app/surprise/$surpriseId';
      final isPremium = planType == PlanType.premium;

      final flower = Flower(
        type: _parseFlowerType(flowerType),
        quantity: flowerIds.length,
      );

      final surprise = Surprise(
        surpriseId: surpriseId,
        creatorId: creatorUid,
        recipientName: recipientName,
        creatorName: creatorName,
        title: 'Sorpresa para $recipientName',
        description: personalMessage,
        customMessage: personalMessage,
        flower: flower,
        photoUrls: photoUrls ?? [],
        videoUrl: videoUrl,
        musicUrl: musicUrl,
        aiLetter: aiLetter,
        specialDate: specialDate,
        publicUrl: publicUrl,
        qrCode: await _generateQRCode(publicUrl),
        status: SurpriseStatus.draft,
        createdAt: DateTime.now(),
        premium: isPremium ? 1 : 0,
        isPremium: isPremium,
      );

      await _surprisesCollection.doc(surpriseId).set(surprise.toMap());

      // Increment surprise count
      await incrementSurpriseCount(creatorUid);

      return surprise;
    } catch (e) {
      throw Exception('Failed to create surprise: $e');
    }
  }

  /// Get surprise by ID
  Future<Surprise?> getSurpriseById(String surpriseId) async {
    try {
      final doc = await _surprisesCollection.doc(surpriseId).get();
      if (!doc.exists) return null;
      return Surprise.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get surprise: $e');
    }
  }

  /// Get user's surprises
  Future<List<Surprise>> getUserSurprises({required String userUid}) async {
    try {
      final query = await _surprisesCollection
          .where('creatorId', isEqualTo: userUid)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Surprise.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user surprises: $e');
    }
  }

  /// Get public surprises (for discovery)
  Future<List<Surprise>> getPublicSurprises() async {
    try {
      final query = await _surprisesCollection
          .where('status', isEqualTo: 'published')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();

      return query.docs
          .map((doc) => Surprise.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get public surprises: $e');
    }
  }

  /// Get surprise by public URL slug
  Future<Surprise?> getSurpriseByPublicUrl(String slug) async {
    try {
      final query = await _surprisesCollection
          .where('publicUrl', isEqualTo: 'https://love14.app/surprise/$slug')
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;
      return Surprise.fromMap(query.docs.first.id, query.docs.first.data());
    } catch (e) {
      throw Exception('Failed to get surprise by URL: $e');
    }
  }

  /// Update surprise
  Future<void> updateSurprise({
    required String surpriseId,
    required String creatorUid,
    required Surprise updatedSurprise,
  }) async {
    try {
      await _surprisesCollection
          .doc(surpriseId)
          .update(updatedSurprise.toMap());
    } catch (e) {
      throw Exception('Failed to update surprise: $e');
    }
  }

  /// Publish surprise (make it public)
  Future<void> publishSurprise({
    required String surpriseId,
    required String creatorUid,
  }) async {
    try {
      await _surprisesCollection.doc(surpriseId).update({
        'status': 'published',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to publish surprise: $e');
    }
  }

  /// Delete surprise
  Future<void> deleteSurprise({
    required String surpriseId,
    required String creatorUid,
  }) async {
    try {
      await _surprisesCollection.doc(surpriseId).delete();
    } catch (e) {
      throw Exception('Failed to delete surprise: $e');
    }
  }

  /// Track view
  Future<void> trackView({required String surpriseId}) async {
    try {
      await _surprisesCollection.doc(surpriseId).update({
        'viewedAt': DateTime.now().toIso8601String(),
        'analytics.views': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to track view: $e');
    }
  }

  // ============ MEDIA UPLOAD ============

  /// Upload photo with progress tracking
  Future<String?> uploadPhoto({
    required File photoFile,
    required String surpriseId,
    int photoIndex = 0,
  }) async {
    try {
      final fileName = 'surprises/$surpriseId/photo_$photoIndex.jpg';
      final ref = _storage.ref(fileName);

      final uploadTask = ref.putFile(photoFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  /// Upload video
  Future<String?> uploadVideo({
    required File videoFile,
    required String surpriseId,
  }) async {
    try {
      final fileName = 'surprises/$surpriseId/video.mp4';
      final ref = _storage.ref(fileName);
      final uploadTask = ref.putFile(videoFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  /// Upload music
  Future<String?> uploadMusic({
    required File musicFile,
    required String surpriseId,
  }) async {
    try {
      final fileName = 'surprises/$surpriseId/music.mp3';
      final ref = _storage.ref(fileName);
      final uploadTask = ref.putFile(musicFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload music: $e');
    }
  }

  // ============ AI LETTER ============

  /// Generate AI letter
  Future<String?> generateAILetter({
    required String recipientName,
    required String senderName,
    required String personalMessage,
    required DateTime specialDate,
  }) async {
    try {
      // TODO: Implement AI letter generation with OpenAI API
      final letter =
          '''
Querido/a $recipientName,

En esta fecha especial ($specialDate), quiero expresar los sentimientos que guardé en mi corazón.

$personalMessage

Con todo mi amor,
$senderName
      ''';
      return letter;
    } catch (e) {
      throw Exception('Failed to generate AI letter: $e');
    }
  }

  // ============ VALIDATION & HELPERS ============

  /// Validate surprise data
  String? validateSurpriseData({
    required String recipientName,
    required String personalMessage,
    required List<String> flowerIds,
    required List<String> photoUrls,
    required PlanType planType,
    String? musicUrl,
    String? videoUrl,
    String? aiLetter,
  }) {
    if (recipientName.isEmpty) return 'El nombre del destinatario es requerido';
    if (personalMessage.isEmpty) return 'El mensaje personal es requerido';
    if (flowerIds.isEmpty) return 'Debe seleccionar al menos una flor';

    // Premium restrictions
    if (planType == PlanType.free) {
      if (flowerIds.length > 1) return 'Plan gratuito: máximo 1 flor';
      if (photoUrls.isNotEmpty) return 'Plan gratuito: sin fotos';
      if (videoUrl != null) return 'Plan gratuito: sin videos';
      if (musicUrl != null) return 'Plan gratuito: sin música';
      if (aiLetter != null) return 'Plan gratuito: sin cartas IA';
    }

    return null;
  }

  /// Check if user has premium access
  Future<bool> hasPremiumAccess(String userUid) async {
    try {
      final plan = await getUserPlan(userUid);
      return plan.isPremium();
    } catch (e) {
      return false;
    }
  }

  /// Get user's current plan
  Future<FreemiumPlan> getUserPlan(String userId) async {
    try {
      final doc = await _usersPlansCollection.doc(userId).get();

      if (!doc.exists) {
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
        upgradeDate: DateTime.now(),
      );

      await _usersPlansCollection.doc(userId).set(updatedPlan.toMap());
    } catch (e) {
      throw Exception('Failed to upgrade to premium: $e');
    }
  }

  /// Increment surprise count
  Future<void> incrementSurpriseCount(String userId) async {
    try {
      await _usersPlansCollection.doc(userId).update({
        'surprisesCreated': FieldValue.increment(1),
      });
    } catch (e) {
      // If document doesn't exist, create it
      try {
        final plan = FreemiumPlan.createFreePlan();
        await _usersPlansCollection.doc(userId).set(plan.toMap());
      } catch (e2) {
        throw Exception('Failed to increment surprise count: $e');
      }
    }
  }

  // ============ PRIVATE HELPERS ============

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

  /// Parse flower type from string
  FlowerType _parseFlowerType(String flowerType) {
    return FlowerType.values.firstWhere(
      (e) => e.toString().split('.').last == flowerType,
      orElse: () => FlowerType.rosa,
    );
  }
}
