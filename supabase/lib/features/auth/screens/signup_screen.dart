import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/core/constants/app_strings.dart';
import 'package:supabase_basic/core/utils/deepLink.dart';
import 'package:supabase_basic/core/widgets/auth_header.dart';
import 'package:supabase_basic/core/widgets/custom_button.dart';
import 'package:supabase_basic/core/widgets/custom_text_field.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/auth/provider/signup_provider.dart';

/// Sign Up screen — pure UI, all logic lives in SignUpProvider.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
    deepLink(context: context);
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final signupProvider = Provider.of<SignUpProvider>(context);

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
                child: CustomTextField(
                      hintText: AppStrings.fullName,
                      prefixIcon: Iconsax.user,
                      controller: signupProvider.nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      errorText: signupProvider.nameError,
                    ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Email ─────────────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: CustomTextField(
                      hintText: AppStrings.email,
                      prefixIcon: Iconsax.sms,
                      controller: signupProvider.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      errorText: signupProvider.emailError,
                    ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Password ──────────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                duration: const Duration(milliseconds: 600),
                child: CustomTextField(
                      hintText: AppStrings.password,
                      prefixIcon: Iconsax.lock,
                      isPassword: true,
                      controller: signupProvider.passwordController,
                      textInputAction: TextInputAction.next,
                      errorText: signupProvider.passwordError,
                    ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Confirm Password ──────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 600),
                child: CustomTextField(
                      hintText: AppStrings.confirmPassword,
                      prefixIcon: Iconsax.lock_1,
                      isPassword: true,
                      controller: signupProvider.confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      errorText: signupProvider.confirmPasswordError,
                    ),
              ),
              const SizedBox(height: AppSizes.xl),

              // ── Create Account button ─────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: CustomButton(
                      text: AppStrings.createAccount,
                      onPressed: () async {
                        final success = await signupProvider.handleSignUp();
                        if (!success && context.mounted) {
                          if (signupProvider.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(signupProvider.errorMessage!)),
                                
                            );
                          }
                        } else if (success && context.mounted) {
                          // Pop all screens back to AuthGate
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      },
                      isLoading: signupProvider.isLoading,
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
