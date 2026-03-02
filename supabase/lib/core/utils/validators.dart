/// Shared form validation utilities.
///
/// Each function returns `null` when valid, or an error message string.
class Validators {
  Validators._();

  /// Validates an email address.
  static String? email(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Please enter your email';
    if (!trimmed.contains('@') || !trimmed.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a non-empty password.
  static String? password(String value) {
    if (value.trim().isEmpty) return 'Please enter your password';
    return null;
  }

  /// Validates a password with minimum length.
  static String? passwordWithLength(String value, {int minLength = 6}) {
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  /// Validates that two passwords match.
  static String? confirmPassword(String password, String confirmPassword) {
    if (confirmPassword != password) return 'Passwords do not match';
    return null;
  }

  /// Validates a non-empty name.
  static String? name(String value) {
    if (value.trim().isEmpty) return 'Please enter your name';
    return null;
  }

  /// Validates a phone number (must start with + and be at least 8 chars).
  static String? phone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'Please enter your phone number';
    if (!trimmed.startsWith('+') || trimmed.length < 8) {
      return 'Enter a valid phone number (e.g. +1234567890)';
    }
    return null;
  }
}
