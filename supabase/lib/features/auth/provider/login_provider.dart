import 'package:flutter/material.dart';
import 'package:supabase_basic/core/utils/validators.dart';
import 'package:supabase_basic/features/auth/authService/auth_service.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _emailError;
  String? _passwordError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  // ── Validation ──────────────────────────────────────────
  bool _validate() {
    _emailError = Validators.email(emailController.text);
    _passwordError = Validators.password(passwordController.text);
    notifyListeners();
    return _emailError == null && _passwordError == null;
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

        if (profile != null) authProvider.setProfile(profile);
        await authProvider.getUserRole(user.id);
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
