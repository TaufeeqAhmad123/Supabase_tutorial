import 'package:flutter/material.dart';
import 'package:supabase_basic/features/auth/authService/auth_service.dart';
import 'package:supabase_basic/model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles global auth state: current user, auth stream, and sign out.
/// Login/SignUp logic lives in their own providers.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // ── Profile state ─────────────────────────────────────────
  Profile? _currentProfile;
  Profile? get currentProfile => _currentProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Current user's email (null if not logged in)
  String? get currentUserEmail => _authService.getCurrentUser();

  /// Current user's ID
  String? get currentUserId => _authService.user?.id;

  /// Auth state changes stream (used by AuthGate)
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  //signin with google
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithGoogle();
      // Fetch the profile right after sign-in
      final userId = _authService.user?.id;
      if (userId != null) {
        _currentProfile = await _authService.getProfile(userId);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Sign in with Google error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //signin with facebook
  Future<void> signInWithFacebook() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _authService.signInWithFacebook();
      // Fetch the profile right after sign-in
      final userId = _authService.user?.id;
      if (userId != null) {
        _currentProfile = await _authService.getProfile(userId);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Sign in with Facebook error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Sign Out ───────────────────────────────────────────
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _currentProfile = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  // ── Get Profile ─────────────────────────────────────────
  Future<void> getProfile(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentProfile = await _authService.getProfile(id);
      notifyListeners();
    } catch (e) {
      debugPrint('Get profile error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Set Profile (used after signup/login to avoid stale state) ──
  void setProfile(Profile profile) {
    _currentProfile = profile;
    notifyListeners();
  }
}
