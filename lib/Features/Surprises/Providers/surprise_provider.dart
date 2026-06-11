import 'package:flutter/material.dart';
import 'package:love14/Features/Surprises/Domain/models/surprise_model.dart';
import 'package:love14/Features/Surprises/Domain/models/flower_model.dart';
import 'package:love14/Features/Surprises/Domain/models/freemium_model.dart';
import 'package:love14/Features/Surprises/Services/surprise_service.dart';
import 'package:love14/Features/Surprises/Services/ai_service.dart';
import 'package:love14/Features/Surprises/Services/payment_service.dart';
import 'dart:io';

class SurpriseProvider extends ChangeNotifier {
  final SurpriseService _surpriseService = SurpriseService();
  final AIService _aiService = AIService();
  final PaymentService _paymentService = PaymentService();

  // State
  List<Surprise> _userSurprises = [];
  Surprise? _currentSurprise;
  FreemiumPlan? _userPlan;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Draft surprise being created
  Surprise? _draftSurprise;
  List<String> _photoUrls = [];
  String? _videoUrl;
  String? _musicUrl;
  String? _aiLetter;

  // Getters
  List<Surprise> get userSurprises => _userSurprises;
  Surprise? get currentSurprise => _currentSurprise;
  FreemiumPlan? get userPlan => _userPlan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  Surprise? get draftSurprise => _draftSurprise;
  List<String> get photoUrls => _photoUrls;
  String? get videoUrl => _videoUrl;
  String? get musicUrl => _musicUrl;
  String? get aiLetter => _aiLetter;
  bool get isPremium => _userPlan?.isPremium() ?? false;
  bool get canCreateSurprise => _userPlan?.canCreateSurprise() ?? false;

  /// Initialize provider for specific user
  Future<void> initializeForUser(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load user's surprises
      _userSurprises = await _surpriseService.getUserSurprises(userId);

      // Load user's plan
      _userPlan = await _surpriseService.getUserPlan(userId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Start creating new surprise
  void startNewSurprise({
    required String creatorId,
    required String recipientName,
    required String creatorName,
    required String title,
    required String description,
    String? customMessage,
    required Flower flower,
    required DateTime specialDate,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _draftSurprise = await _surpriseService.createSurprise(
        creatorId: creatorId,
        recipientName: recipientName,
        creatorName: creatorName,
        title: title,
        description: description,
        customMessage: customMessage,
        flower: flower,
        specialDate: specialDate,
        isPremium: isPremium,
      );

      // Increment surprise count
      await _surpriseService.incrementSurpriseCount(creatorId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add photos to draft surprise
  Future<void> addPhotos(List<String> photoPaths) async {
    if (_draftSurprise == null) {
      _errorMessage = 'No surprise in draft';
      notifyListeners();
      return;
    }

    if (!isPremium || !(_userPlan?.hasFeature(PlanFeature.photos) ?? false)) {
      _errorMessage = 'Photos only available for premium';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Upload photos
      for (int i = 0; i < photoPaths.length; i++) {
        // Read image bytes
        final imageFile = File(photoPaths[i]);
        final imageBytes = await imageFile.readAsBytes();

        final downloadUrl = await _surpriseService.uploadPhoto(
          _draftSurprise!.surpriseId,
          imageBytes,
          i,
        );

        _photoUrls.add(downloadUrl);
      }

      _isLoading = false;
      notifyListeners();
      _successMessage = 'Photos added successfully';
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add video to draft surprise
  Future<void> addVideo(String videoPath) async {
    if (_draftSurprise == null) {
      _errorMessage = 'No surprise in draft';
      notifyListeners();
      return;
    }

    if (!isPremium || !(_userPlan?.hasFeature(PlanFeature.videos) ?? false)) {
      _errorMessage = 'Videos only available for premium';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      _videoUrl = await _surpriseService.uploadVideo(
        _draftSurprise!.surpriseId,
        videoPath,
      );

      _isLoading = false;
      notifyListeners();
      _successMessage = 'Video added successfully';
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add music to draft surprise
  Future<void> addMusic(String musicPath) async {
    if (_draftSurprise == null) {
      _errorMessage = 'No surprise in draft';
      notifyListeners();
      return;
    }

    if (!isPremium ||
        !(_userPlan?.hasFeature(PlanFeature.customMusic) ?? false)) {
      _errorMessage = 'Custom music only available for premium';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      _musicUrl = await _surpriseService.uploadMusic(
        _draftSurprise!.surpriseId,
        musicPath,
      );

      _isLoading = false;
      notifyListeners();
      _successMessage = 'Music added successfully';
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generate AI letter
  Future<void> generateAILetter({
    required String occasion,
    String? theme,
  }) async {
    if (!isPremium || !(_userPlan?.hasFeature(PlanFeature.aiLetter) ?? false)) {
      _errorMessage = 'AI letters only available for premium';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      _aiLetter = await _aiService.generateRomanticLetter(
        creatorName: _draftSurprise?.creatorName ?? '',
        recipientName: _draftSurprise?.recipientName ?? '',
        occasion: occasion,
        customTheme: theme,
      );

      _isLoading = false;
      notifyListeners();
      _successMessage = 'Letter generated successfully';
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Publish surprise (make it public)
  Future<void> publishSurprise() async {
    if (_draftSurprise == null) {
      _errorMessage = 'No surprise to publish';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      // Update draft with media URLs
      final updatedSurprise = _draftSurprise!.copyWith(
        photoUrls: _photoUrls,
        videoUrl: _videoUrl,
        musicUrl: _musicUrl,
        aiLetter: _aiLetter,
        status: SurpriseStatus.published,
      );

      await _surpriseService.updateSurprise(
        _draftSurprise!.surpriseId,
        updatedSurprise.toMap(),
      );

      await _surpriseService.publishSurprise(_draftSurprise!.surpriseId);

      _currentSurprise = updatedSurprise;

      // Add to user surprises list
      if (!_userSurprises.any((s) => s.surpriseId == updatedSurprise.surpriseId)) {
        _userSurprises.insert(0, updatedSurprise);
      }

      _draftSurprise = null;
      _photoUrls = [];
      _videoUrl = null;
      _musicUrl = null;
      _aiLetter = null;

      _isLoading = false;
      notifyListeners();
      _successMessage = 'Surprise published successfully!';
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load specific surprise
  Future<void> loadSurprise(String surpriseId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentSurprise = await _surpriseService.getSurprise(surpriseId);

      // Mark as viewed if accessing public link
      if (_currentSurprise != null) {
        await _surpriseService.markAsViewed(surpriseId);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh user's surprises
  Future<void> refreshSurprises(String userId) async {
    try {
      _userSurprises = await _surpriseService.getUserSurprises(userId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Delete surprise
  Future<void> deleteSurprise(String surpriseId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _surpriseService.deleteSurprise(surpriseId);

      _userSurprises.removeWhere((s) => s.surpriseId == surpriseId);

      _isLoading = false;
      notifyListeners();
      _successMessage = 'Surprise deleted';
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Upgrade to premium
  Future<bool> upgradeToPremium(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Call payment service
      await _paymentService.processPremiumUpgrade(
        userId: userId,
        paymentToken: 'token_premium_upgrade',
        months: 12,
      );

      // Reload plan
      _userPlan = await _surpriseService.getUserPlan(userId);

      _isLoading = false;
      notifyListeners();
      _successMessage = 'Upgraded to premium!';
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear messages
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Reset draft
  void resetDraft() {
    _draftSurprise = null;
    _photoUrls = [];
    _videoUrl = null;
    _musicUrl = null;
    _aiLetter = null;
    notifyListeners();
  }
}


