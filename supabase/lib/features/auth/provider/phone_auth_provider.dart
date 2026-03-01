import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_basic/features/auth/authService/auth_service.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Manages phone OTP authentication flow:
/// send code → verify code → create profile.
class PhoneAuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _phoneError;

  // Resend countdown
  int _resendSeconds = 0;
  Timer? _resendTimer;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get phoneError => _phoneError;
  int get resendSeconds => _resendSeconds;
  bool get canResend => _resendSeconds == 0;

  /// The phone number that was sent the OTP (used on the OTP screen).
  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  // ── Validation ──────────────────────────────────────────
  bool _validatePhone() {
    _phoneError = null;

    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      _phoneError = 'Please enter your phone number';
      notifyListeners();
      return false;
    }
    // Basic check: must start with + and be at least 8 chars
    if (!phone.startsWith('+') || phone.length < 8) {
      _phoneError = 'Enter a valid phone number (e.g. +1234567890)';
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }

  // ── Send OTP ────────────────────────────────────────────
  Future<bool> sendOtp() async {
    if (!_validatePhone()) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _phoneNumber = phoneController.text.trim();
      await _authService.signInWithPhone(_phoneNumber);
      _startResendTimer();
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      print(e.message);
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      print(e.toString());
      notifyListeners();
      return false;
    }
  }

  // ── Verify OTP ──────────────────────────────────────────
  Future<bool> verifyOtp(AuthProvider authProvider) async {
    final code = otpController.text.trim();
    if (code.length != 6) {
      _errorMessage = 'Please enter the 6-digit code';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.verifyPhoneOtp(_phoneNumber, code);
      final user = response.user;
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

  // ── Resend Timer ────────────────────────────────────────
  void _startResendTimer() {
    _resendSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _resendSeconds--;
      notifyListeners();
      if (_resendSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  // ── Resend OTP ──────────────────────────────────────────
  Future<void> resendOtp() async {
    if (!canResend) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.signInWithPhone(_phoneNumber);
      _startResendTimer();
    } on AuthException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Clear ───────────────────────────────────────────────
  void clearFields() {
    phoneController.clear();
    otpController.clear();
    _phoneError = null;
    _errorMessage = null;
    _resendSeconds = 0;
    _resendTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }
}
