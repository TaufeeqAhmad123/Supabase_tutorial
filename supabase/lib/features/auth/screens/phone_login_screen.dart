import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/core/constants/app_strings.dart';
import 'package:supabase_basic/core/theme/page_transitions.dart';
import 'package:supabase_basic/core/widgets/auth_header.dart';
import 'package:supabase_basic/core/widgets/custom_button.dart';
import 'package:supabase_basic/core/widgets/custom_text_field.dart';
import 'package:supabase_basic/features/auth/provider/phone_auth_provider.dart';
import 'package:supabase_basic/features/auth/screens/otp_screen.dart';
/// Screen where users enter their phone number to receive an OTP.
class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phoneProv = Provider.of<PhoneAuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.xl),

              // ── Back button ───────────────────────────────
              FadeInLeft(
                duration: const Duration(milliseconds: 500),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Iconsax.arrow_left, size: 24),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        side: BorderSide(
                          color: isDark
                              ? AppColors.inputBorderDark
                              : AppColors.inputBorder,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.md),

              // ── Header ────────────────────────────────────
              const AuthHeader(
                icon: Iconsax.call_calling,
                title: AppStrings.phoneLogin,
                subtitle: AppStrings.phoneLoginSubtitle,
              ),

              const SizedBox(height: AppSizes.xxl),

              // ── Phone number field ────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: CustomTextField(
                  hintText: AppStrings.phoneHint,
                  prefixIcon: Iconsax.call,
                  controller: phoneProv.phoneController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  errorText: phoneProv.phoneError,
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              // ── Helper text ───────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xs),
                  child: Row(
                    children: [
                      Icon(
                        Iconsax.info_circle,
                        size: 14,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      const SizedBox(width: AppSizes.xs),
                      Text(
                        'Include country code (e.g. +92, +1)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.xl),

              // ── Error message ─────────────────────────────
              if (phoneProv.errorMessage != null)
                FadeInUp(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.md),
                    margin: const EdgeInsets.only(bottom: AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Iconsax.warning_2,
                          size: 18,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: AppSizes.sm),
                        Expanded(
                          child: Text(
                            phoneProv.errorMessage!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Send Code button ──────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 600),
                child: CustomButton(
                  text: AppStrings.sendCode,
                  icon: Iconsax.send_1,
                  isLoading: phoneProv.isLoading,
                  onPressed: () async {
                    final success = await phoneProv.sendOtp();
                    if (success && context.mounted) {
                      Navigator.of(
                        context,
                      ).push(AppPageTransitions.slideRight(const OtpScreen()));
                    }
                  },
                ),
              ),

              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }
}
