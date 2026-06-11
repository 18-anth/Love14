import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:love14/models/couple_model.dart';
import 'package:love14/models/user_model.dart';
import 'package:love14/services/auth_service.dart';
import 'package:love14/services/firebase_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirebaseService _firebaseService = FirebaseService();

  // State variables
  fa.User? _firebaseUser;
  User? _userProfile;
  Couple? _userCouple;
  User? _partnerProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  fa.User? get firebaseUser => _firebaseUser;
  User? get userProfile => _userProfile;
  Couple? get userCouple => _userCouple;
  User? get partnerProfile => _partnerProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _firebaseUser != null;
  bool get hasCouple => _userCouple != null;

  // Initialize provider - listen to auth state changes
  void initialize() {
    _authService.authStateChanges.listen((faUser) async {
      _firebaseUser = faUser;

      if (faUser != null) {
        // User signed in - load their profile
        try {
          _userProfile = await _firebaseService.getUser(faUser.uid);
          _userCouple = await _firebaseService.getCoupleByUserId(faUser.uid);
          if (_userCouple != null) {
            _partnerProfile = await _authService.getCurrentUserPartner();
          }
          _errorMessage = null;
        } catch (e) {
          _errorMessage = 'Failed to load user profile: $e';
        }
      } else {
        // User signed out - clear state
        _userProfile = null;
        _userCouple = null;
        _partnerProfile = null;
        _errorMessage = null;
      }

      notifyListeners();
    });
  }

  // ============ AUTHENTICATION METHODS ============

  /// Sign up new couple
  Future<bool> signUpCouple({
    required String email1,
    required String password1,
    required String name1,
    required String email2,
    required String password2,
    required String name2,
    String? coupleName,
    DateTime? anniversaryDate,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.signUpCouple(
        email1: email1,
        password1: password1,
        name1: name1,
        email2: email2,
        password2: password2,
        name2: name2,
        coupleName: coupleName,
        anniversaryDate: anniversaryDate,
      );

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

  /// Sign in user
  Future<bool> signIn(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.signIn(email, password);

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

  /// Sign out
  Future<bool> signOut() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.signOut();

      // State will be cleared by listener
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

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.sendPasswordResetEmail(email);

      _isLoading = false;
      _errorMessage = 'Password reset email sent';
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updatePassword(newPassword);

      _isLoading = false;
      _errorMessage = 'Password updated successfully';
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.deleteAccount();

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

  // ============ USER PROFILE METHODS ============

  /// Update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      if (_firebaseUser == null) {
        _errorMessage = 'No user signed in';
        notifyListeners();
        return false;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      await _firebaseService.updateUser(_firebaseUser!.uid, updates);

      // Reload profile
      _userProfile = await _firebaseService.getUser(_firebaseUser!.uid);

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

  /// Refresh couple data
  Future<bool> refreshCoupleData() async {
    try {
      if (_firebaseUser == null) {
        _errorMessage = 'No user signed in';
        notifyListeners();
        return false;
      }

      _userCouple = await _firebaseService.getCoupleByUserId(_firebaseUser!.uid);
      if (_userCouple != null) {
        _partnerProfile = await _authService.getCurrentUserPartner();
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Update couple data
  Future<bool> updateCoupleData({
    String? coupleName,
    DateTime? anniversaryDate,
  }) async {
    try {
      if (_userCouple == null) {
        _errorMessage = 'No couple associated with user';
        notifyListeners();
        return false;
      }

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updates = <String, dynamic>{};
      if (coupleName != null) updates['coupleName'] = coupleName;
      if (anniversaryDate != null) {
        updates['anniversaryDate'] = anniversaryDate.toIso8601String();
      }

      await _firebaseService.updateCouple(_userCouple!.coupleId, updates);

      // Reload couple data
      await refreshCoupleData();

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

  // ============ EMAIL VERIFICATION ============

  /// Send email verification
  Future<bool> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
      _errorMessage = 'Verification email sent';
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  /// Check if email is verified
  bool get isEmailVerified => _authService.isEmailVerified();

  /// Reload auth state
  Future<void> reloadAuthState() async {
    try {
      await _authService.reloadAuthUser();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  // ============ CLEAR ERROR ============

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
