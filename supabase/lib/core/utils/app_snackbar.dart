import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';

/// Beautiful, premium scaffold-messenger snackbars.
///
/// Usage:
/// ```dart
/// AppSnackbar.success(context, message: 'Account created!');
/// AppSnackbar.error(context, message: 'Invalid credentials');
/// AppSnackbar.info(context, message: 'OTP sent to your phone');
/// ```
class AppSnackbar {
  AppSnackbar._();

  // ── Success ──────────────────────────────────────────────
  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      title: title ?? 'Success',
      message: message,
      icon: Iconsax.tick_circle5,
      backgroundColor: const Color(0xFF0D1F17),
      borderColor: AppColors.success,
      iconColor: AppColors.success,
      titleColor: AppColors.success,
      duration: duration,
    );
  }

  // ── Error ────────────────────────────────────────────────
  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      title: title ?? 'Oops!',
      message: message,
      icon: Iconsax.close_circle5,
      backgroundColor: const Color(0xFF1F0D14),
      borderColor: AppColors.error,
      iconColor: AppColors.error,
      titleColor: AppColors.error,
      duration: duration,
    );
  }

  // ── Info ──────────────────────────────────────────────────
  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      title: title ?? 'Heads up',
      message: message,
      icon: Iconsax.info_circle5,
      backgroundColor: const Color(0xFF0D1520),
      borderColor: AppColors.info,
      iconColor: AppColors.info,
      titleColor: AppColors.info,
      duration: duration,
    );
  }

  // ── Warning ──────────────────────────────────────────────
  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      title: title ?? 'Warning',
      message: message,
      icon: Iconsax.warning_25,
      backgroundColor: const Color(0xFF1F1A0D),
      borderColor: AppColors.warning,
      iconColor: AppColors.warning,
      titleColor: AppColors.warning,
      duration: duration,
    );
  }

  // ── Core ─────────────────────────────────────────────────
  static void _show(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
    required Color backgroundColor,
    required Color borderColor,
    required Color iconColor,
    required Color titleColor,
    required Duration duration,
  }) {
    // Dismiss any existing snackbar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? backgroundColor
        : backgroundColor == const Color(0xFF0D1F17)
        ? const Color(0xFFE8FAF0)
        : backgroundColor == const Color(0xFF1F0D14)
        ? const Color(0xFFFDE8EE)
        : backgroundColor == const Color(0xFF0D1520)
        ? const Color(0xFFE6F0FA)
        : const Color(0xFFFAF3E6);

    final msgColor = isDark ? Colors.white70 : Colors.black87;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm + 2,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: borderColor.withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: borderColor.withValues(alpha: isDark ? 0.25 : 0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Icon ──
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: isDark ? 0.15 : 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),

              const SizedBox(width: AppSizes.sm + 4),

              // ── Text ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        color: msgColor,
                        fontSize: 13,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSizes.xs),

              // ── Dismiss ──
              GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: Icon(
                  Icons.close_rounded,
                  color: isDark ? Colors.white38 : Colors.black38,
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        // Transparent background because we draw our own container
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          left: AppSizes.md,
          right: AppSizes.md,
          bottom: AppSizes.md,
        ),
        padding: EdgeInsets.zero,
        duration: duration,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
