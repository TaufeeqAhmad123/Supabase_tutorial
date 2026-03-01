import 'package:flutter/material.dart';
import 'package:supabase_basic/features/auth/authService/auth_service.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // ── Validation errors ───────────────────────────────────
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  bool _validate() {
    _nameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;

    bool valid = true;

    if (nameController.text.trim().isEmpty) {
      _nameError = 'Please enter your name';
      valid = false;
    }

    if (emailController.text.trim().isEmpty) {
      _emailError = 'Please enter your email';
      valid = false;
    } else if (!emailController.text.contains('@')) {
      _emailError = 'Enter a valid email address';
      valid = false;
    }

    if (passwordController.text.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      valid = false;
    }

    if (confirmPasswordController.text != passwordController.text) {
      _confirmPasswordError = 'Passwords do not match';
      valid = false;
    }

    notifyListeners();
    return valid;
  }

  // ── Handle Sign Up ──────────────────────────────────────
  Future<bool> handleSignUp(AuthProvider authProvider) async {
    if (!_validate()) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.createAccountWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      // Check if profile already exists (e.g. user previously signed in with Google)
      final user = _authService.user;
      if (user != null) {
        final existingProfile = await _authService.getProfile(user.id);
        if (existingProfile == null) {
          // No profile yet, create one
          final newProfile = await _authService.createProfile(
            nameController.text.trim(),
            emailController.text.trim(),
            '', // no avatar for email sign-up
            'email', // provider
          );
          // Immediately set the profile on AuthProvider so it's
          // available before HomeScreen loads (avoids showing 'User').
          authProvider.setProfile(newProfile);
        } else {
          // Profile already exists, set it on AuthProvider
          authProvider.setProfile(existingProfile);
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
      print(e);

      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ── Clear all fields ────────────────────────────────────
  void clearFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    _nameError = null;
    _emailError = null;
    _passwordError = null;
    _confirmPasswordError = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
