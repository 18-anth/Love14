import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:love14/models/couple_model.dart';
import 'package:love14/models/user_model.dart';
import 'package:love14/services/firebase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final fa.FirebaseAuth _auth = fa.FirebaseAuth.instance;
  final FirebaseService _firebaseService = FirebaseService();

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  // Get current user
  fa.User? get currentUser => _auth.currentUser;

  // Get current user stream
  Stream<fa.User?> get authStateChanges => _auth.authStateChanges();

  // ============ AUTHENTICATION ============

  /// Sign up new couple (creates 2 Firebase Auth users)
  /// Returns couple ID on success
  Future<String> signUpCouple({
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
      // Create first user
      final cred1 = await _auth.createUserWithEmailAndPassword(
        email: email1,
        password: password1,
      );
      final uid1 = cred1.user!.uid;

      // Create user record in Firestore
      final user1 = User(
        uid: uid1,
        email: email1,
        name: name1,
        createdAt: DateTime.now(),
      );
      await _firebaseService.createUser(user1);

      // Sign out first user
      await _auth.signOut();

      // Create second user
      final cred2 = await _auth.createUserWithEmailAndPassword(
        email: email2,
        password: password2,
      );
      final uid2 = cred2.user!.uid;

      // Create second user record in Firestore
      final user2 = User(
        uid: uid2,
        email: email2,
        name: name2,
        createdAt: DateTime.now(),
      );
      await _firebaseService.createUser(user2);

      // Sign out second user
      await _auth.signOut();

      // Create couple record
      final couple = Couple(
        coupleId: '', // Will be set by Firebase
        userIds: [uid1, uid2],
        coupleName: coupleName,
        anniversaryDate: anniversaryDate,
        createdAt: DateTime.now(),
      );

      final coupleId = await _firebaseService.createCouple(couple);

      // Sign in first user (to resume session)
      await _auth.signInWithEmailAndPassword(
        email: email1,
        password: password1,
      );

      return coupleId;
    } on fa.FirebaseAuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Sign in user
  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on fa.FirebaseAuthException catch (e) {
      throw Exception('Sign in failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on fa.FirebaseAuthException catch (e) {
      throw Exception('Password reset failed: ${e.message}');
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Update password (for current user)
  Future<void> updatePassword(String newPassword) async {
    try {
      if (currentUser == null) {
        throw Exception('No user signed in');
      }
      await currentUser!.updatePassword(newPassword);
    } on fa.FirebaseAuthException catch (e) {
      throw Exception('Password update failed: ${e.message}');
    } catch (e) {
      throw Exception('Password update failed: $e');
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    try {
      if (currentUser == null) {
        throw Exception('No user signed in');
      }

      final uid = currentUser!.uid;

      // Delete Firestore user record
      await _firebaseService.updateUser(uid, {
        'deletedAt': DateTime.now().toIso8601String(),
      });

      // Delete Firebase Auth user
      await currentUser!.delete();
    } on fa.FirebaseAuthException catch (e) {
      throw Exception('Account deletion failed: ${e.message}');
    } catch (e) {
      throw Exception('Account deletion failed: $e');
    }
  }

  // ============ USER RETRIEVAL ============

  /// Get current user's full profile from Firestore
  Future<User?> getCurrentUserProfile() async {
    if (currentUser == null) return null;
    return _firebaseService.getUser(currentUser!.uid);
  }

  /// Get current user's couple
  Future<Couple?> getCurrentUserCouple() async {
    if (currentUser == null) return null;
    return _firebaseService.getCoupleByUserId(currentUser!.uid);
  }

  /// Get current user's partner in couple
  Future<User?> getCurrentUserPartner() async {
    if (currentUser == null) return null;

    final couple = await getCurrentUserCouple();
    if (couple == null) return null;

    // Find partner (the other user in couple)
    final partnerId = couple.userIds.firstWhere(
      (uid) => uid != currentUser!.uid,
      orElse: () => '',
    );

    if (partnerId.isEmpty) return null;

    return _firebaseService.getUser(partnerId);
  }

  // ============ EMAIL VERIFICATION ============

  /// Send email verification to current user
  Future<void> sendEmailVerification() async {
    try {
      if (currentUser == null) {
        throw Exception('No user signed in');
      }
      if (!currentUser!.emailVerified) {
        await currentUser!.sendEmailVerification();
      }
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }

  /// Check if current user's email is verified
  bool isEmailVerified() {
    return currentUser?.emailVerified ?? false;
  }

  /// Reload auth state (useful after email verification)
  Future<void> reloadAuthUser() async {
    try {
      if (currentUser == null) {
        throw Exception('No user signed in');
      }
      await currentUser!.reload();
    } catch (e) {
      throw Exception('Auth reload failed: $e');
    }
  }
}
