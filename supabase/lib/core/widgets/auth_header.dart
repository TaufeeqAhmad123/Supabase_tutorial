import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';

/// A reusable header widget that shows an illustration placeholder,
/// a title, and an optional subtitle with staggered fade-in animations.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.illustrationSize,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final double? illustrationSize;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final size = illustrationSize ?? AppSizes.illustrationSize;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // ── Illustration circle ────────────────────────────
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Container(
            width: size * 0.55,
            height: size * 0.55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: isDark ? 0.25 : 0.12),
                  AppColors.accent.withValues(alpha: isDark ? 0.15 : 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              icon,
              size: size * 0.25,
              color: iconColor ?? AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.lg),

        // ── Title ──────────────────────────────────────────
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 600),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
        ),

        // ── Subtitle ───────────────────────────────────────
        if (subtitle != null) ...[
          const SizedBox(height: AppSizes.sm),
          FadeInDown(
            delay: const Duration(milliseconds: 350),
            duration: const Duration(milliseconds: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
              child: Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
