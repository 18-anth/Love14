import 'dart:io';
import 'package:flutter/material.dart';
import 'package:love14/services/surprise_service.dart';
import 'package:love14/models/surprise_model.dart';
import 'package:love14/models/freemium_model.dart';

class SurpriseProvider extends ChangeNotifier {
  final SurpriseService _service = SurpriseService();

  // State variables
  List<Surprise> _userSurprises = [];
  List<Surprise> _publicSurprises = [];
  Surprise? _currentSurprise;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _errorMessage;
  double _uploadProgress = 0.0;
  bool _isPremium = false;

  // Getters
  List<Surprise> get userSurprises => _userSurprises;
  List<Surprise> get publicSurprises => _publicSurprises;
  Surprise? get currentSurprise => _currentSurprise;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;
  double get uploadProgress => _uploadProgress;
  bool get isPremium => _isPremium;

  // Statistics
  int get totalSurprises => _userSurprises.length;
  int get publishedSurprises =>
      _userSurprises.where((s) => s.status == SurpriseStatus.published).length;
  int get draftSurprises =>
      _userSurprises.where((s) => s.status == SurpriseStatus.draft).length;

  // ============ INITIALIZATION ============

  /// Initialize for user
  Future<void> initializeForUser(String userUid) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Load user plan
      final plan = await _service.getUserPlan(userUid);
      _isPremium = plan.isPremium();

      // Load user surprises
      await loadMySurprises(userUid);

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============ CREATE SURPRISE ============

  /// Create new surprise with all details
  Future<Surprise?> createSurprise({
    required String userUid,
    required String userName,
    required String recipientName,
    required String personalMessage,
    required String flowerType,
    required List<String> flowerIds,
    required DateTime specialDate,
    String? musicUrl,
    List<String>? photoUrls,
    String? videoUrl,
    String? aiLetter,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Check plan type
      final hasPremium = await _service.hasPremiumAccess(userUid);
      final planType = hasPremium ? PlanType.premium : PlanType.free;

      // Validate
      final validation = _service.validateSurpriseData(
        recipientName: recipientName,
        personalMessage: personalMessage,
        flowerIds: flowerIds,
        photoUrls: photoUrls ?? [],
        planType: planType,
        musicUrl: musicUrl,
        videoUrl: videoUrl,
        aiLetter: aiLetter,
      );

      if (validation != null) {
        throw Exception(validation);
      }

      // Create surprise
      final surprise = await _service.createSurprise(
        creatorUid: userUid,
        creatorName: userName,
        recipientName: recipientName,
        personalMessage: personalMessage,
        flowerType: flowerType,
        flowerIds: flowerIds,
        specialDate: specialDate,
        planType: planType,
        musicUrl: musicUrl,
        photoUrls: photoUrls,
        videoUrl: videoUrl,
        aiLetter: aiLetter,
      );

      _currentSurprise = surprise;
      _userSurprises.insert(0, surprise);
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();

      return surprise;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // ============ LOAD SURPRISES ============

  /// Load user's surprises
  Future<void> loadMySurprises(String userUid) async {
    try {
      _isLoading = true;
      notifyListeners();

      _userSurprises = await _service.getUserSurprises(userUid: userUid);
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load public surprises (for discovery)
  Future<void> loadPublicSurprises() async {
    try {
      _isLoading = true;
      notifyListeners();

      _publicSurprises = await _service.getPublicSurprises();
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load single surprise by ID
  Future<void> loadSurpriseById(String surpriseId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentSurprise = await _service.getSurpriseById(surpriseId);

      if (_currentSurprise != null) {
        await _service.trackView(surpriseId: surpriseId);
      }

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load surprise by public URL slug
  Future<void> loadPublicSurprise(String slug) async {
    try {
      _isLoading = true;
      notifyListeners();

      _currentSurprise = await _service.getSurpriseByPublicUrl(slug);

      if (_currentSurprise != null) {
        await _service.trackView(surpriseId: _currentSurprise!.surpriseId);
      }

      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load surprise (alias for loadSurpriseById)
  Future<void> loadSurprise(String surpriseId) async {
    await loadSurpriseById(surpriseId);
  }

  // ============ UPDATE SURPRISE ============

  /// Update surprise details
  Future<bool> updateSurprise({
    required String userUid,
    required Surprise updatedSurprise,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _service.updateSurprise(
        surpriseId: updatedSurprise.surpriseId,
        creatorUid: userUid,
        updatedSurprise: updatedSurprise,
      );

      // Update local state
      final index = _userSurprises.indexWhere(
        (s) => s.surpriseId == updatedSurprise.surpriseId,
      );
      if (index != -1) {
        _userSurprises[index] = updatedSurprise;
      }

      if (_currentSurprise?.surpriseId == updatedSurprise.surpriseId) {
        _currentSurprise = updatedSurprise;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Publish surprise (make it public)
  Future<bool> publishSurprise({
    required String userUid,
    required String surpriseId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _service.publishSurprise(
        surpriseId: surpriseId,
        creatorUid: userUid,
      );

      // Update local state
      final index = _userSurprises.indexWhere(
        (s) => s.surpriseId == surpriseId,
      );
      if (index != -1) {
        final updated = _userSurprises[index].copyWith(
          status: SurpriseStatus.published,
        );
        _userSurprises[index] = updated;

        if (_currentSurprise?.surpriseId == surpriseId) {
          _currentSurprise = updated;
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete surprise
  Future<bool> deleteSurprise({
    String? userUid,
    required String surpriseId,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _service.deleteSurprise(
        surpriseId: surpriseId,
        creatorUid: userUid ?? 'unknown',
      );

      _userSurprises.removeWhere((s) => s.surpriseId == surpriseId);

      if (_currentSurprise?.surpriseId == surpriseId) {
        _currentSurprise = null;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
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
      _isUploading = true;
      _uploadProgress = 0.0;
      notifyListeners();

      final url = await _service.uploadPhoto(
        photoFile: photoFile,
        surpriseId: surpriseId,
        photoIndex: photoIndex,
      );

      _uploadProgress = 1.0;
      _isUploading = false;
      notifyListeners();

      return url;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isUploading = false;
      notifyListeners();
      return null;
    }
  }

  /// Upload video
  Future<String?> uploadVideo({
    required File videoFile,
    required String surpriseId,
  }) async {
    try {
      _isUploading = true;
      _uploadProgress = 0.0;
      notifyListeners();

      final url = await _service.uploadVideo(
        videoFile: videoFile,
        surpriseId: surpriseId,
      );

      _uploadProgress = 1.0;
      _isUploading = false;
      notifyListeners();

      return url;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isUploading = false;
      notifyListeners();
      return null;
    }
  }

  /// Upload music
  Future<String?> uploadMusic({
    required File musicFile,
    required String surpriseId,
  }) async {
    try {
      _isUploading = true;
      _uploadProgress = 0.0;
      notifyListeners();

      final url = await _service.uploadMusic(
        musicFile: musicFile,
        surpriseId: surpriseId,
      );

      _uploadProgress = 1.0;
      _isUploading = false;
      notifyListeners();

      return url;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isUploading = false;
      notifyListeners();
      return null;
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
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final letter = await _service.generateAILetter(
        recipientName: recipientName,
        senderName: senderName,
        personalMessage: personalMessage,
        specialDate: specialDate,
      );

      _isLoading = false;
      notifyListeners();

      return letter;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // ============ PREMIUM ============

  /// Upgrade to premium
  Future<bool> upgradeToPremium(String userUid) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _service.upgradeToPremium(userUid);
      _isPremium = true;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ============ HELPER METHODS ============

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear current surprise
  void clearCurrent() {
    _currentSurprise = null;
    notifyListeners();
  }

  /// Refresh surprises
  Future<void> refreshSurprises(String userUid) async {
    await loadMySurprises(userUid);
  }

  /// Refresh (alias)
  Future<void> refresh(String userUid) async {
    await loadMySurprises(userUid);
  }
}
