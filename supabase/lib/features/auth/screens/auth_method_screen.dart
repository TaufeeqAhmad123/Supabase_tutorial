import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/core/constants/app_strings.dart';
import 'package:supabase_basic/core/theme/page_transitions.dart';
import 'package:supabase_basic/core/widgets/custom_button.dart';
import 'package:supabase_basic/features/auth/screens/login_screen.dart';
import 'package:supabase_basic/features/auth/screens/phone_login_screen.dart';

/// Screen shown after onboarding — lets the user choose
/// between Email or Phone Number authentication.
class AuthMethodScreen extends StatelessWidget {
  const AuthMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Illustration ────────────────────────────────
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(
                          alpha: isDark ? 0.25 : 0.12,
                        ),
                        AppColors.accent.withValues(
                          alpha: isDark ? 0.15 : 0.06,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            width: 2,
                          ),
                        ),
                      ),
                      const Icon(
                        Iconsax.security_user,
                        size: 52,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.xxl),

              // ── Title ───────────────────────────────────────
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  AppStrings.chooseMethod,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSizes.md),

              // ── Subtitle ────────────────────────────────────
              FadeInDown(
                delay: const Duration(milliseconds: 350),
                duration: const Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
                  child: Text(
                    AppStrings.chooseMethodSubtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // ── Email Button ────────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: CustomButton(
                  icon: Iconsax.sms,
                  text: AppStrings.continueWithEmail,
                  gradient: AppColors.primaryGradient,
                  shadowColor: AppColors.primary,
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(AppPageTransitions.fadeSlide(const LoginScreen()));
                  },
                ),
              ),

              const SizedBox(height: AppSizes.md),

              // ── Phone Button ────────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 650),
                duration: const Duration(milliseconds: 600),
                child: CustomButton(
                  icon: Iconsax.call,
                  text: AppStrings.continueWithPhone,
                  gradient: AppColors.accentGradient,
                  shadowColor: AppColors.accent,
                  onPressed: () {
                    Navigator.of(context).push(
                      AppPageTransitions.fadeSlide(const PhoneLoginScreen()),
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSizes.xxl),
            ],
          ),
        ),
      ),
    );
  }
}
