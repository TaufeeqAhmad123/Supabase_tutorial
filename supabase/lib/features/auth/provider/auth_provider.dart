import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_basic/features/auth/authService/auth_service.dart';
import 'package:supabase_basic/model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles global auth state: current user, auth stream, and sign out.
/// Login/SignUp logic lives in their own providers.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ImagePicker _imagePicker = ImagePicker();

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

  String? _userRole;
  String? get userRole => _userRole;

  Future<void> getUserRole(String id) async {
    try {
      _userRole = await _authService.getUserRole(id);
    } catch (e) {
      debugPrint('Get user role error: $e');
    }
    notifyListeners();
  }

  /// Pick an image from the gallery and upload it as the profile avatar.
  Future<void> pickAndUploadProfileImage() async {
    try {
      final result = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (result == null) return; // user cancelled

      _isLoading = true;
      notifyListeners();

      final file = File(result.path);
      await _authService.setProfileImage(file);

      // Refresh the cached profile so the avatar updates in the UI
      final userId = _authService.user?.id;
      if (userId != null) {
        _currentProfile = await _authService.getProfile(userId);
      }
    } catch (e) {
      debugPrint('Set profile image error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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
        _userRole = await _authService.getUserRole(userId);
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
      _userRole = null;
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

  void setUserRole(String role) {
    _userRole = role;
    notifyListeners();
  }
}
