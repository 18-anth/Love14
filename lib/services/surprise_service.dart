import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SurpriseService {
  static final SurpriseService _instance = SurpriseService._internal();
  
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Base URL for public surprises (configure según tu dominio)
  static const String publicBaseUrl = 'https://love14.app/surprise';

  SurpriseService._internal();

  factory SurpriseService() {
    return _instance;
  }

  // ============ CREATE SURPRISE ============

  /// Create a new surprise and save to Firebase
  Future<SurpriseModel> createSurprise({
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
      
      // Generate public URL and QR code
      final publicUrl = '$publicBaseUrl/$surpriseId';
      final qrCodeData = await _generateQRCode(publicUrl);
      
      // Calculate expiration (30 days from now)
      final expiresAt = DateTime.now().add(Duration(days: 30));

      final surprise = SurpriseModel(
        surpriseId: surpriseId,
        creatorUid: creatorUid,
        creatorName: creatorName,
        recipientName: recipientName,
        personalMessage: personalMessage,
        flowerType: flowerType,
        flowerIds: flowerIds,
        musicUrl: musicUrl,
        photoUrls: photoUrls ?? [],
        videoUrl: videoUrl,
        specialDate: specialDate,
        aiLetter: aiLetter,
        publicUrl: publicUrl,
        qrCode: qrCodeData,
        status: SurpriseStatus.draft,
        planType: planType,
        viewCount: 0,
        createdAt: DateTime.now(),
        expiresAt: expiresAt,
      );

      // Save to Firebase Realtime Database
      await _database
          .ref('surprises/$surpriseId')
          .set(surprise.toMap());

      // Save to user's surprises index
      await _database
          .ref('users/$creatorUid/surprises/$surpriseId')
          .set({
            'status': SurpriseStatus.draft.toString().split('.').last,
            'createdAt': DateTime.now().toIso8601String(),
          });

      return surprise;
    } catch (e) {
      throw Exception('Failed to create surprise: $e');
    }
  }

  // ============ UPDATE SURPRISE ============

  /// Update surprise details
  Future<void> updateSurprise({
    required String surpriseId,
    required String creatorUid,
    required SurpriseModel updatedSurprise,
  }) async {
    try {
      // Verify ownership
      final existing = await getSurpriseById(surpriseId);
      if (existing == null || existing.creatorUid != creatorUid) {
        throw Exception('Unauthorized: Only creator can update surprise');
      }

      await _database
          .ref('surprises/$surpriseId')
          .update(updatedSurprise.toMap());
    } catch (e) {
      throw Exception('Failed to update surprise: $e');
    }
  }

  /// Publish surprise (make it public/shareable)
  Future<void> publishSurprise({
    required String surpriseId,
    required String creatorUid,
  }) async {
    try {
      final surprise = await getSurpriseById(surpriseId);
      if (surprise == null || surprise.creatorUid != creatorUid) {
        throw Exception('Unauthorized');
      }

      await _database
          .ref('surprises/$surpriseId/status')
          .set(SurpriseStatus.published.toString().split('.').last);

      // Add to public surprises index
      await _database
          .ref('public/surprises/${surprise.publicUrl!.split('/').last}')
          .set({
            'surpriseId': surpriseId,
            'recipientName': surprise.recipientName,
            'creatorName': surprise.creatorName,
            'publishedAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      throw Exception('Failed to publish surprise: $e');
    }
  }

  /// Delete surprise (only if draft)
  Future<void> deleteSurprise({
    required String surpriseId,
    required String creatorUid,
  }) async {
    try {
      final surprise = await getSurpriseById(surpriseId);
      if (surprise == null || surprise.creatorUid != creatorUid) {
        throw Exception('Unauthorized');
      }

      if (surprise.status != SurpriseStatus.draft) {
        throw Exception('Cannot delete published surprises');
      }

      // Delete from surprises
      await _database.ref('surprises/$surpriseId').remove();

      // Delete from user's surprises
      await _database
          .ref('users/$creatorUid/surprises/$surpriseId')
          .remove();

      // Delete associated media from Storage
      await _deleteMediaFromStorage(surpriseId);
    } catch (e) {
      throw Exception('Failed to delete surprise: $e');
    }
  }

  // ============ RETRIEVE SURPRISES ============

  /// Get single surprise by ID
  Future<SurpriseModel?> getSurpriseById(String surpriseId) async {
    try {
      final event = await _database.ref('surprises/$surpriseId').once();
      if (event.snapshot.value != null) {
        final map = Map<String, dynamic>.from(event.snapshot.value as Map);
        return SurpriseModel.fromMap(surpriseId, map);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch surprise: $e');
    }
  }

  /// Get all surprises created by user (paginated)
  Future<List<SurpriseModel>> getUserSurprises({
    required String userUid,
    int limit = 20,
  }) async {
    try {
      final event = await _database
          .ref('users/$userUid/surprises')
          .limitToFirst(limit)
          .once();

      if (event.snapshot.value == null) return [];

      final surpriseIds = (event.snapshot.value as Map).keys.cast<String>();
      final surprises = <SurpriseModel>[];

      for (final id in surpriseIds) {
        final surprise = await getSurpriseById(id);
        if (surprise != null) {
          surprises.add(surprise);
        }
      }

      return surprises;
    } catch (e) {
      throw Exception('Failed to fetch user surprises: $e');
    }
  }

  /// Get surprise by public URL slug
  Future<SurpriseModel?> getSurpriseByPublicUrl(String slug) async {
    try {
      final event = await _database
          .ref('public/surprises/$slug')
          .once();

      if (event.snapshot.value == null) return null;

      final map = Map<String, dynamic>.from(event.snapshot.value as Map);
      final surpriseId = map['surpriseId'] as String;

      return getSurpriseById(surpriseId);
    } catch (e) {
      throw Exception('Failed to fetch public surprise: $e');
    }
  }

  /// Get all public surprises (for discovery/trending)
  Future<List<SurpriseModel>> getPublicSurprises({
    int limit = 50,
  }) async {
    try {
      final event = await _database
          .ref('public/surprises')
          .limitToFirst(limit)
          .once();

      if (event.snapshot.value == null) return [];

      final publicSurprises = (event.snapshot.value as Map);
      final surprises = <SurpriseModel>[];

      for (final entry in publicSurprises.values) {
        final map = Map<String, dynamic>.from(entry as Map);
        final surprise = await getSurpriseById(map['surpriseId']);
        if (surprise != null && !surprise.isExpired()) {
          surprises.add(surprise);
        }
      }

      return surprises;
    } catch (e) {
      throw Exception('Failed to fetch public surprises: $e');
    }
  }

  // ============ MEDIA UPLOAD ============

  /// Upload photo to Firebase Storage
  Future<String> uploadPhoto({
    required File photoFile,
    required String surpriseId,
    int photoIndex = 0,
  }) async {
    try {
      final fileName =
          'surprises/$surpriseId/photos/photo_$photoIndex.jpg';
      final ref = _storage.ref(fileName);
      final uploadTask = ref.putFile(photoFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

  /// Upload video to Firebase Storage
  Future<String> uploadVideo({
    required File videoFile,
    required String surpriseId,
  }) async {
    try {
      final fileName = 'surprises/$surpriseId/video/main_video.mp4';
      final ref = _storage.ref(fileName);
      final uploadTask = ref.putFile(videoFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  /// Upload audio/music to Firebase Storage
  Future<String> uploadMusic({
    required File musicFile,
    required String surpriseId,
  }) async {
    try {
      final fileName = 'surprises/$surpriseId/music/background.mp3';
      final ref = _storage.ref(fileName);
      final uploadTask = ref.putFile(musicFile);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload music: $e');
    }
  }

  // ============ AI LETTER GENERATION ============

  /// Generate romantic letter using AI
  /// Note: Requires integration with OpenAI, Anthropic, or similar
  Future<String> generateAILetter({
    required String recipientName,
    required String senderName,
    required String personalMessage,
    required DateTime specialDate,
  }) async {
    try {
      // TODO: Implement actual AI integration
      // This is a placeholder that returns a template
      // Integration with OpenAI API example:
      
      final aiLetter = _generateLetterTemplate(
        senderName: senderName,
        recipientName: recipientName,
        personalMessage: personalMessage,
        specialDate: specialDate,
      );

      return aiLetter;
    } catch (e) {
      throw Exception('Failed to generate AI letter: $e');
    }
  }

  // ============ QR CODE GENERATION ============

  /// Generate QR code for public URL
  Future<String> _generateQRCode(String data) async {
    try {
      final qrImage = await QrPainter(
        data: data,
        version: QrVersions.auto,
        gapless: false,
      ).toImageData(200);

      // Save QR code image and return base64
      final bytes = qrImage!.buffer.asUint8List();
      return base64Encode(bytes);
    } catch (e) {
      throw Exception('Failed to generate QR code: $e');
    }
  }

  // ============ VIEW TRACKING ============

  /// Increment view count for a surprise
  Future<void> trackView({
    required String surpriseId,
  }) async {
    try {
      final surprise = await getSurpriseById(surpriseId);
      if (surprise == null) throw Exception('Surprise not found');

      final newViewCount = surprise.viewCount + 1;

      await _database
          .ref('surprises/$surpriseId')
          .update({
            'viewCount': newViewCount,
            'status': surprise.status == SurpriseStatus.draft
                ? SurpriseStatus.viewed.toString().split('.').last
                : surprise.status.toString().split('.').last,
          });
    } catch (e) {
      throw Exception('Failed to track view: $e');
    }
  }

  // ============ HELPER METHODS ============

  /// Delete all media associated with a surprise
  Future<void> _deleteMediaFromStorage(String surpriseId) async {
    try {
      final dirRef = _storage.ref('surprises/$surpriseId');
      final items = await dirRef.listAll();

      for (final item in items.items) {
        await item.delete();
      }
    } catch (e) {
      // Silently fail - media might not exist
      print('Warning: Failed to delete media for $surpriseId: $e');
    }
  }

  /// Generate template romantic letter
  String _generateLetterTemplate({
    required String senderName,
    required String recipientName,
    required String personalMessage,
    required DateTime specialDate,
  }) {
    final dateString =
        '${specialDate.day}/${specialDate.month}/${specialDate.year}';

    return '''
Mi querida $recipientName,

En este especial día de $dateString, quería tomar un momento para expresar los sentimientos que guarda mi corazón.

$personalMessage

Eres la razón de mis sonrisas, la luz en mis días oscuros, y el amor que hace latir mi corazón. Cada momento contigo es un regalo precioso que atesoro profundamente.

Con todo mi amor,
$senderName

P.S. Espero que esta sorpresa especial te haga sentir lo mucho que significa para mí.
''';
  }

  /// Check if user has premium access (integration with payment system)
  Future<bool> hasPremiumAccess(String userUid) async {
    try {
      final event = await _database
          .ref('users/$userUid/subscription')
          .once();

      if (event.snapshot.value == null) return false;

      final map = Map<String, dynamic>.from(event.snapshot.value as Map);
      final isActive = map['isActive'] as bool? ?? false;
      final expiresAt = map['expiresAt'] as String?;

      if (!isActive) return false;

      if (expiresAt != null) {
        final expireDate = DateTime.parse(expiresAt);
        return expireDate.isAfter(DateTime.now());
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get user's active surprise count (for free tier limit)
  Future<int> getActiveSurpriseCount(String userUid) async {
    try {
      final surprises = await getUserSurprises(userUid: userUid);
      return surprises
          .where((s) =>
              s.status == SurpriseStatus.published &&
              !s.isExpired())
          .length;
    } catch (e) {
      return 0;
    }
  }

  /// Validate surprise data before creation
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
    // Basic validations
    if (recipientName.trim().isEmpty) {
      return 'Recipient name is required';
    }

    if (personalMessage.trim().isEmpty) {
      return 'Personal message is required';
    }

    if (flowerIds.isEmpty) {
      return 'At least one flower must be selected';
    }

    // Free tier restrictions
    if (planType == PlanType.free) {
      if (flowerIds.length > 1) {
        return 'Free tier: Maximum 1 flower';
      }
      if (photoUrls.length > 1) {
        return 'Free tier: Maximum 1 photo';
      }
      if (musicUrl != null) {
        return 'Music is a premium feature';
      }
      if (videoUrl != null) {
        return 'Videos are a premium feature';
      }
      if (aiLetter != null && aiLetter.isNotEmpty) {
        return 'AI Letters are a premium feature';
      }
    }

    return null; // Valid
  }
}
