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

  /// Auth state changes stream (used by AuthGate) — cached, same instance always.
  late final Stream<User?> authStateChanges = _authService.authStateChanges;

  /// Current user from the active session (point-in-time, non-stream).
  User? get currentSessionUser => _authService.currentSessionUser;

  // ── Social Sign-In (shared helper) ─────────────────────
  Future<void> _socialSignIn(
    Future<void> Function() signInFn,
    String label,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await signInFn();
      final userId = _authService.user?.id;
      if (userId != null) {
        _currentProfile = await _authService.getProfile(userId);
      }
    } catch (e) {
      debugPrint('$label error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() =>
      _socialSignIn(_authService.signInWithGoogle, 'Google sign-in');

  /// Sign in with Facebook
  Future<void> signInWithFacebook() =>
      _socialSignIn(_authService.signInWithFacebook, 'Facebook sign-in');

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
