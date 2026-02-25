import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/core/constants/app_strings.dart';
import 'package:supabase_basic/core/widgets/auth_header.dart';
import 'package:supabase_basic/core/widgets/custom_button.dart';
import 'package:supabase_basic/core/widgets/custom_text_field.dart';
import 'package:supabase_basic/features/auth/provider/signup_provider.dart';

/// Sign Up screen — pure UI, all logic lives in SignUpProvider.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                icon: Iconsax.user_add,
                title: AppStrings.signUpTitle,
                subtitle: AppStrings.signUpSubtitle,
              ),

              const SizedBox(height: AppSizes.xl),

              // ── Name ──────────────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: Consumer<SignUpProvider>(
                  builder: (context, signUpProv, _) {
                    return CustomTextField(
                      hintText: AppStrings.fullName,
                      prefixIcon: Iconsax.user,
                      controller: signUpProv.nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      errorText: signUpProv.nameError,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Email ─────────────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: Consumer<SignUpProvider>(
                  builder: (context, signUpProv, _) {
                    return CustomTextField(
                      hintText: AppStrings.email,
                      prefixIcon: Iconsax.sms,
                      controller: signUpProv.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      errorText: signUpProv.emailError,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Password ──────────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 600),
                child: Consumer<SignUpProvider>(
                  builder: (context, signUpProv, _) {
                    return CustomTextField(
                      hintText: AppStrings.password,
                      prefixIcon: Iconsax.lock,
                      isPassword: true,
                      controller: signUpProv.passwordController,
                      textInputAction: TextInputAction.next,
                      errorText: signUpProv.passwordError,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Confirm Password ──────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 600),
                child: Consumer<SignUpProvider>(
                  builder: (context, signUpProv, _) {
                    return CustomTextField(
                      hintText: AppStrings.confirmPassword,
                      prefixIcon: Iconsax.lock_1,
                      isPassword: true,
                      controller: signUpProv.confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      errorText: signUpProv.confirmPasswordError,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // ── Create Account button ─────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: Consumer<SignUpProvider>(
                  builder: (context, signUpProv, _) {
                    return CustomButton(
                      text: AppStrings.createAccount,
                      onPressed: () async {
                        final success = await signUpProv.handleSignUp();
                        if (!success && context.mounted) {
                          if (signUpProv.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(signUpProv.errorMessage!)),
                                
                            );
                          }
                        } else if (success && context.mounted) {
                          // Pop all screens back to AuthGate
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      },
                      isLoading: signUpProv.isLoading,
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── Navigate to Login ─────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 900),
                duration: const Duration(milliseconds: 600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text(
                        AppStrings.login,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
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
