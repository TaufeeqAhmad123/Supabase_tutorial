import 'package:flutter/material.dart';
import 'package:supabase_basic/core/utils/validators.dart';
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
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get nameError => _nameError;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;

  // ── Validation ──────────────────────────────────────────
  bool _validate() {
    _nameError = Validators.name(nameController.text);
    _emailError = Validators.email(emailController.text);
    _passwordError = Validators.passwordWithLength(passwordController.text);
    _confirmPasswordError = Validators.confirmPassword(
      passwordController.text,
      confirmPasswordController.text,
    );
    notifyListeners();
    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
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
          final newProfile = await _authService.createProfile(
            nameController.text.trim(),
            emailController.text.trim(),
            '',
            'email',
          );
          authProvider.setProfile(newProfile);
        } else {
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
