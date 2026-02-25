import 'package:flutter/material.dart';

/// Premium color palette for the app.
/// Inspired by modern fintech / startup aesthetics.
class AppColors {
  AppColors._();

  // ── Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFF6C63FF); // Vibrant indigo
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF4A40E0);

  // ── Secondary / Accent ───────────────────────────────────
  static const Color accent = Color(0xFF00D9A6); // Mint / teal accent
  static const Color accentLight = Color(0xFF5EFFD0);
  static const Color accentDark = Color(0xFF00B389);

  // ── Backgrounds ──────────────────────────────────────────
  static const Color scaffoldLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color scaffoldDark = Color(0xFF0D0D1A);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  static const Color cardDark = Color(0xFF222240);

  // ── Text ─────────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1E1E2D);
  static const Color textSecondaryLight = Color(0xFF7B7B93);
  static const Color textPrimaryDark = Color(0xFFF5F5FA);
  static const Color textSecondaryDark = Color(0xFFA0A0B8);

  // ── Utility ──────────────────────────────────────────────
  static const Color error = Color(0xFFFF4D6A);
  static const Color success = Color(0xFF00D68F);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = Color(0xFF3399FF);
  static const Color divider = Color(0xFFE8E8F0);
  static const Color dividerDark = Color(0xFF2E2E48);
  static const Color inputBorder = Color(0xFFD8D8E8);
  static const Color inputBorderDark = Color(0xFF3A3A58);
  static const Color shadow = Color(0x1A6C63FF);

  // ── Gradients ────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00D9A6), Color(0xFF00B389)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF3B2FCC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0D0D1A), Color(0xFF1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
