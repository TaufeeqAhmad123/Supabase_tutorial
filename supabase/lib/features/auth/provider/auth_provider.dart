import 'package:flutter/material.dart';
import 'package:supabase_basic/features/auth/authService/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Handles global auth state: current user, auth stream, and sign out.
/// Login/SignUp logic lives in their own providers.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  /// Current user's email (null if not logged in)
  String? get currentUserEmail => _authService.getCurrentUser();

  /// Auth state changes stream (used by AuthGate)
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // ── Sign Out ───────────────────────────────────────────
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
    notifyListeners();
  }
  
}
