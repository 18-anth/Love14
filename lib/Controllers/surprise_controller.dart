import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:love14/models/user_model.dart';
import 'package:love14/models/flower_model.dart';
import 'package:love14/services/firebase_service.dart';
import 'package:love14/services/auth_service.dart';
import 'package:love14/services/payment_service.dart';

class SurpriseController with ChangeNotifier {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _realtimeDb = FirebaseDatabase.instance;
  
  // Services
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  final PaymentService _paymentService = PaymentService();

  // State variables
  List<Surprise> _userSurprises = [];
  Surprise? _currentSurprise;
  bool _isLoading = false;
  bool _isCreating = false;
  bool _isPublishing = false;
  String? _errorMessage;
  double _uploadProgress = 0.0;
  Map<String, int> _viewCounters = {};
  bool _isPremiumUser = false;

  // Getters
  List<Surprise> get userSurprises => _userSurprises;
  Surprise? get currentSurprise => _currentSurprise;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  bool get isPublishing => _isPublishing;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  bool get isPremiumUser => _isPremiumUser;
  
  // Computed properties
  int get totalSurprises => _userSurprises.length;
  int get publishedSurprises =>
      _userSurprises.where((s) => s.status == SurpriseStatus.published).length;
  int get draftSurprises =>
      _userSurprises.where((s) => s.status == SurpriseStatus.draft).length;
  int get totalViews => _viewCounters.values.fold(0, (a, b) => a + b);

  // Constants
  static const String _surprisesCollection = 'surprises';
  static const String _viewsPath = 'surpriseViews';
  static const String _shareBaseUrl = 'https://love14.app/surprise';
  static const int _freeSurpriseLimit = 1;
  static const int _maxPhotosFree = 1;
  static const int _maxPhotosPremimu = 20;
  static const int _freeSurpriseDurationDays = 7;
  static const int _premiumSurpriseDurationDays = 30;

  // ============ INITIALIZATION ============

  /// Initialize controller for current user
  Future<void> initializeForUser() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Check premium status
      await _checkPremiumStatus(user.uid);

      // Load user surprises
      await loadUserSurprises(user.uid);

      // Load view counters
      await _loadViewCounters();

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check if user has premium plan
  Future<void> _checkPremiumStatus(String userId) async {
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;
      _isPremiumUser = data?['isPremium'] ?? false;
    } catch (e) {
      _isPremiumUser = false;
    }
  }

  /// Load all surprises for user
  Future<void> loadUserSurprises(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_surprisesCollection)
          .where('creatorId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      _userSurprises = snapshot.docs
          .map((doc) => Surprise.fromMap(doc.data() as String, doc.id as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error loading surprises: $e');
    }
  }

  /// Load view counters from realtime database
  Future<void> _loadViewCounters() async {
    try {
      for (final surprise in _userSurprises) {
        final viewsSnapshot =
            await _realtimeDb.ref('$_viewsPath/${surprise.surpriseId}').get();
        
        if (viewsSnapshot.exists) {
          final viewsData = viewsSnapshot.value as Map<dynamic, dynamic>;
          _viewCounters[surprise.surpriseId] = viewsData.length;
        } else {
          _viewCounters[surprise.surpriseId] = 0;
        }
      }
    } catch (e) {
      debugPrint('Error loading view counters: $e');
    }
  }

  // ============ CREATE SURPRISE ============

  /// Validate user can create new surprise
  Future<bool> canCreateSurprise(String userId) async {
    try {
      if (!_isPremiumUser) {
        // Check free tier limit
        if (publishedSurprises >= _freeSurpriseLimit) {
          _errorMessage =
              'Has alcanzado el límite de sorpresas gratis. ¡Actualiza a Premium!';
          notifyListeners();
          return false;
        }
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Create new surprise draft
  Future<Surprise?> createSurpriseDraft({
    required String creatorName,
    required String recipientName,
    required String title,
    required String description,
    required FlowerType flowerType,
    DateTime? specialDate,
  }) async {
    try {
      _isCreating = true;
      _errorMessage = null;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Generate IDs
      const uuid = Uuid();
      final surpriseId = uuid.v4();

      // Create Flower object from type
      final flower = Flower(
        id: uuid.v4(),
        type: flowerType,
        quantity: 1,
        color: _getDefaultFlowerColor(flowerType),
      );

      // Create surprise with draft status
      final surprise = Surprise(
        surpriseId: surpriseId,
        creatorId: user.uid,
        recipientName: recipientName,
        creatorName: creatorName,
        title: title,
        description: description,
        flower: flower,
        specialDate: specialDate ?? DateTime.now().add(Duration(days: 7)),
        publicUrl: '$_shareBaseUrl/$surpriseId',
        qrCode: await _generateQRCode(surpriseId),
        status: SurpriseStatus.draft,
        createdAt: DateTime.now(),
        premium: _isPremiumUser ? 1 : 0,
      );

      // Save to Firestore
      await _firestore
          .collection(_surprisesCollection)
          .doc(surpriseId)
          .set(surprise.toMap());

      // Add to local list
      _userSurprises.insert(0, surprise);
      _currentSurprise = surprise;
      _viewCounters[surpriseId] = 0;

      _isCreating = false;
      notifyListeners();

      return surprise;
    } catch (e) {
      _errorMessage = 'Error creating surprise: $e';
      _isCreating = false;
      notifyListeners();
      return null;
    }
  }

  /// Update surprise draft
  Future<bool> updateSurpriseDraft({
    required String surpriseId,
    String? customMessage,
    String? musicUrl,
    List<String>? photoUrls,
    String? videoUrl,
    String? aiLetter,
  }) async {
    try {
      _isCreating = true;
      notifyListeners();

      final updateData = <String, dynamic>{};

      if (customMessage != null) updateData['customMessage'] = customMessage;
      if (musicUrl != null) updateData['musicUrl'] = musicUrl;
      if (photoUrls != null) updateData['photoUrls'] = photoUrls;
      if (videoUrl != null) updateData['videoUrl'] = videoUrl;
      if (aiLetter != null) updateData['aiLetter'] = aiLetter;

      // Validate premium features
      if (!_isPremiumUser) {
        if (photoUrls != null && photoUrls.length > _maxPhotosFree) {
          throw Exception('Plan gratis: máximo $_maxPhotosFree foto');
        }
        if (videoUrl != null) {
          throw Exception('Vídeos disponibles en plan Premium');
        }
        if (musicUrl != null) {
          throw Exception('Música personalizada disponible en plan Premium');
        }
      }

      // Update in Firestore
      await _firestore
          .collection(_surprisesCollection)
          .doc(surpriseId)
          .update(updateData);

      // Update local surprise
      if (_currentSurprise?.surpriseId == surpriseId) {
        _currentSurprise = _currentSurprise!.copyWith(
          customMessage: customMessage,
          musicUrl: musicUrl,
          photoUrls: photoUrls,
          videoUrl: videoUrl,
          aiLetter: aiLetter,
        );
      }

      _isCreating = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error updating surprise: $e';
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  // ============ PUBLISH SURPRISE ============

  /// Publish surprise and make it public
  Future<bool> publishSurprise(String surpriseId) async {
    try {
      _isPublishing = true;
      _errorMessage = null;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Verify surprise exists and belongs to user
      final surprise = _userSurprises
          .firstWhere((s) => s.surpriseId == surpriseId, orElse: () => throw Exception('Sorpresa no encontrada'));

      if (surprise.creatorId != user.uid) {
        throw Exception('No tienes permiso para publicar esta sorpresa');
      }

      // Calculate expiration date
      final expiresAt = DateTime.now().add(
        Duration(
          days: _isPremiumUser
              ? _premiumSurpriseDurationDays
              : _freeSurpriseDurationDays,
        ),
      );

      // Update status
      await _firestore
          .collection(_surprisesCollection)
          .doc(surpriseId)
          .update({
        'status': SurpriseStatus.published.toString().split('.').last,
        'expiresAt': expiresAt.toIso8601String(),
      });

      // Update local state
      final index =
          _userSurprises.indexWhere((s) => s.surpriseId == surpriseId);
      if (index != -1) {
        final updatedSurprise = _userSurprises[index].copyWith(
          status: SurpriseStatus.published,
          expiresAt: expiresAt,
        );
        _userSurprises[index] = updatedSurprise;
        if (_currentSurprise?.surpriseId == surpriseId) {
          _currentSurprise = updatedSurprise;
        }
      }

      _isPublishing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error publishing surprise: $e';
      _isPublishing = false;
      notifyListeners();
      return false;
    }
  }

  // ============ SHARE LINK & QR ============

  /// Generate unique share link
  String generateShareLink(String surpriseId) {
    return '$_shareBaseUrl/$surpriseId';
  }

  /// Generate QR code as base64
  Future<String> _generateQRCode(String surpriseId) async {
    try {
      final qrValidator = QrValidator.validate(
        data: generateShareLink(surpriseId),
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
      );

      if (qrValidator.isValid) {
        // Return link as QR representation (will be generated on demand in UI)
        return surpriseId; // Store ID, generate QR in widget
      }
      return '';
    } catch (e) {
      debugPrint('Error generating QR: $e');
      return '';
    }
  }

  // ============ VIEWS TRACKING ============

  /// Track view of surprise
  Future<void> trackSurpriseView(String surpriseId) async {
    try {
      final viewId = const Uuid().v4();
      final timestamp = DateTime.now().toIso8601String();

      // Save to realtime database (for real-time updates)
      await _realtimeDb.ref('$_viewsPath/$surpriseId/$viewId').set({
        'timestamp': timestamp,
        'userAgent': 'flutter-app',
      });

      // Update view counter locally
      _viewCounters[surpriseId] = (_viewCounters[surpriseId] ?? 0) + 1;

      // Update analytics in Firestore
      await _firestore
          .collection(_surprisesCollection)
          .doc(surpriseId)
          .update({
        'analytics.views': FieldValue.increment(1),
        'viewedAt': timestamp,
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Error tracking view: $e');
    }
  }

  /// Get view count for surprise
  int getViewCount(String surpriseId) {
    return _viewCounters[surpriseId] ?? 0;
  }

  /// Track share action
  Future<void> trackShare(String surpriseId) async {
    try {
      await _firestore
          .collection(_surprisesCollection)
          .doc(surpriseId)
          .update({
        'analytics.shares': FieldValue.increment(1),
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Error tracking share: $e');
    }
  }

  // ============ DELETE & ARCHIVE ============

  /// Delete surprise
  Future<bool> deleteSurprise(String surpriseId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Verify ownership
      final surprise = _userSurprises
          .firstWhere((s) => s.surpriseId == surpriseId, orElse: () => null!);
      
      if (surprise == null || surprise.creatorId != user.uid) {
        throw Exception('No tienes permiso para eliminar esta sorpresa');
      }

      // Delete from Firestore
      await _firestore
          .collection(_surprisesCollection)
          .doc(surpriseId)
          .delete();

      // Delete from realtime database
      await _realtimeDb.ref('$_viewsPath/$surpriseId').remove();

      // Remove from local list
      _userSurprises.removeWhere((s) => s.surpriseId == surpriseId);
      _viewCounters.remove(surpriseId);

      if (_currentSurprise?.surpriseId == surpriseId) {
        _currentSurprise = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error deleting surprise: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Archive surprise
  Future<bool> archiveSurprise(String surpriseId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore
          .collection(_surprisesCollection)
          .doc(surpriseId)
          .update({
        'status': SurpriseStatus.archived.toString().split('.').last,
      });

      // Update local state
      final index =
          _userSurprises.indexWhere((s) => s.surpriseId == surpriseId);
      if (index != -1) {
        _userSurprises[index] =
            _userSurprises[index].copyWith(status: SurpriseStatus.archived);
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error archiving surprise: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============ DUPLICATE SURPRISE ============

  /// Duplicate existing surprise as draft
  Future<Surprise?> duplicateSurprise(String surpriseId) async {
    try {
      _isCreating = true;
      notifyListeners();

      final surprise = _userSurprises.firstWhere(
        (s) => s.surpriseId == surpriseId,
        orElse: () => null!,
      );

      if (surprise == null) {
        throw Exception('Sorpresa no encontrada');
      }

      // Generate new ID
      const uuid = Uuid();
      final newId = uuid.v4();

      // Create new surprise with same data
      final duplicated = Surprise(
        surpriseId: newId,
        creatorId: surprise.creatorId,
        recipientName: surprise.recipientName,
        creatorName: surprise.creatorName,
        title: '${surprise.title} (Copia)',
        description: surprise.description,
        customMessage: surprise.customMessage,
        flower: surprise.flower,
        photoUrls: surprise.photoUrls,
        videoUrl: surprise.videoUrl,
        musicUrl: surprise.musicUrl,
        aiLetter: surprise.aiLetter,
        specialDate: surprise.specialDate,
        publicUrl: '$_shareBaseUrl/$newId',
        qrCode: await _generateQRCode(newId),
        status: SurpriseStatus.draft,
        createdAt: DateTime.now(),
        premium: surprise.premium,
      );

      // Save to Firestore
      await _firestore
          .collection(_surprisesCollection)
          .doc(newId)
          .set(duplicated.toMap());

      // Add to local list
      _userSurprises.insert(0, duplicated);
      _viewCounters[newId] = 0;

      _isCreating = false;
      notifyListeners();

      return duplicated;
    } catch (e) {
      _errorMessage = 'Error duplicating surprise: $e';
      _isCreating = false;
      notifyListeners();
      return null;
    }
  }

  // ============ UTILITY METHODS ============

  /// Get default color for flower type
  String _getDefaultFlowerColor(FlowerType type) {
    switch (type) {
      case FlowerType.rosa:
        return '#FF1493'; // Deep Pink
      case FlowerType.girasol:
        return '#FFD700'; // Gold
      case FlowerType.tulipan:
        return '#FF69B4'; // Hot Pink
      case FlowerType.margarita:
        return '#FFD700'; // Gold
      case FlowerType.clavel:
        return '#FF6347'; // Tomato
      case FlowerType.lirio:
        return '#9370DB'; // Medium Purple
      case FlowerType.orquidea:
        return '#DA70D6'; // Orchid
      case FlowerType.amapola:
        return '#FF4500'; // Red Orange
      case FlowerType.loto:
        return '#FF1493'; // Deep Pink
      case FlowerType.sakura:
        return '#FFB7C5'; // Cherry Blossom
    }
  }

  /// Get surprise by ID from network (for public view)
  Future<Surprise?> getSurpriseById(String surpriseId) async {
    try {
      final doc = await _firestore
          .collection(_surprisesCollection)
          .doc(surpriseId)
          .get();

      if (!doc.exists) return null;

      final surprise = Surprise.fromMap(doc.data()! as String, doc.id as Map<String, dynamic>);

      // Check if expired
      if (surprise.isExpired()) {
        return null;
      }

      return surprise;
    } catch (e) {
      debugPrint('Error fetching surprise: $e');
      return null;
    }
  }

  /// Search surprises by recipient name (admin feature)
  Future<List<Surprise>> searchSurprises(String query) async {
    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection(_surprisesCollection)
          .where('recipientName', isGreaterThanOrEqualTo: query)
          .where('recipientName', isLessThan: query + 'z')
          .get();

      final results = snapshot.docs
          .map((doc) => Surprise.fromMap(doc.data() as String, doc.id as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();

      return results;
    } catch (e) {
      _errorMessage = 'Error searching surprises: $e';
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Get user surprises list
  List<Surprise> getUserSurprises() {
    return _userSurprises;
  }

  /// Upgrade user to premium plan
  Future<void> upgradeToPremium() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      await _firestore.collection('users').doc(user.uid).update({
        'isPremium': true,
        'premiumExpiresAt': DateTime.now().add(const Duration(days: 30)),
      });

      _isPremiumUser = true;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error upgrading to premium: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Reset controller state
  void reset() {
    _userSurprises = [];
    _currentSurprise = null;
    _isLoading = false;
    _isCreating = false;
    _isPublishing = false;
    _errorMessage = null;
    _uploadProgress = 0.0;
    _viewCounters = {};
    notifyListeners();
  }
}
