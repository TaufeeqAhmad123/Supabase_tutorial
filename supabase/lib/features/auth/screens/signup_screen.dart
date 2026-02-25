import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/core/constants/app_strings.dart';
import 'package:supabase_basic/core/theme/page_transitions.dart';
import 'package:supabase_basic/core/widgets/auth_header.dart';
import 'package:supabase_basic/core/widgets/custom_button.dart';
import 'package:supabase_basic/core/widgets/custom_text_field.dart';

import 'email_verification_screen.dart';

/// Sign Up screen with name, email, password, confirm password.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // Validation state
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    // Reset errors
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    // Simple client validation
    bool hasError = false;
    if (_nameController.text.trim().isEmpty) {
      _nameError = 'Please enter your name';
      hasError = true;
    }
    if (_emailController.text.trim().isEmpty) {
      _emailError = 'Please enter your email';
      hasError = true;
    } else if (!_emailController.text.contains('@')) {
      _emailError = 'Enter a valid email address';
      hasError = true;
    }
    if (_passwordController.text.length < 6) {
      _passwordError = 'Password must be at least 6 characters';
      hasError = true;
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      _confirmPasswordError = 'Passwords do not match';
      hasError = true;
    }

    if (hasError) {
      setState(() {});
      return;
    }

    // Simulate loading
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(
          context,
        ).push(AppPageTransitions.fadeSlide(const EmailVerificationScreen()));
      }
    });
  }

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
                child: CustomTextField(
                  hintText: AppStrings.fullName,
                  prefixIcon: Iconsax.user,
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  errorText: _nameError,
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
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  errorText: _emailError,
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
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  errorText: _passwordError,
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
                  controller: _confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  errorText: _confirmPasswordError,
                ),
              ),
              const SizedBox(height: AppSizes.xl),

              // ── Create Account button ─────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: CustomButton(
                  text: AppStrings.createAccount,
                  onPressed: _handleSignUp,
                  isLoading: _isLoading,
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
