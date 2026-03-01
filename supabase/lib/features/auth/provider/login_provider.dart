import 'package:flutter/material.dart';
import 'package:supabase_basic/features/auth/authService/auth_service.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ── Validation ──────────────────────────────────────────
  String? _emailError;
  String? _passwordError;

  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  bool _validate() {
    _emailError = null;
    _passwordError = null;

    bool valid = true;

    if (emailController.text.trim().isEmpty) {
      _emailError = 'Please enter your email';
      valid = false;
    } else if (!emailController.text.contains('@')) {
      _emailError = 'Enter a valid email address';
      valid = false;
    }

    if (passwordController.text.trim().isEmpty) {
      _passwordError = 'Please enter your password';
      valid = false;
    }

    notifyListeners();
    return valid;
  }

  // ── Handle Login ────────────────────────────────────────
  Future<bool> handleLogin(AuthProvider authProvider) async {
    if (!_validate()) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Fetch and set profile immediately so it's available on HomeScreen
      final user = _authService.user;
      if (user != null) {
        final profile = await _authService.getProfile(user.id);
        if (profile != null) {
          authProvider.setProfile(profile);
        }
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Clear all fields ────────────────────────────────────
  void clearFields() {
    emailController.clear();
    passwordController.clear();
    _emailError = null;
    _passwordError = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
