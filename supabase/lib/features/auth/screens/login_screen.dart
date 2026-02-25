import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/auth_header.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/social_login_button.dart';
import '../../core/widgets/or_divider.dart';
import '../../core/theme/page_transitions.dart';
import 'signup_screen.dart';

/// Login screen with illustration, email/password fields,
/// social login buttons, and a link to Sign Up.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // UI-only: simulate loading
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isLoading = false);
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
              const SizedBox(height: AppSizes.xxl),

              // ── Header ────────────────────────────────────
              const AuthHeader(
                icon: Iconsax.lock_1,
                title: AppStrings.welcomeBack,
                subtitle: AppStrings.loginSubtitle,
              ),

              const SizedBox(height: AppSizes.xxl),

              // ── Email field ───────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                duration: const Duration(milliseconds: 600),
                child: CustomTextField(
                  hintText: AppStrings.email,
                  prefixIcon: Iconsax.sms,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Password field ────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: CustomTextField(
                  hintText: AppStrings.password,
                  prefixIcon: Iconsax.lock,
                  isPassword: true,
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                ),
              ),

              // ── Forgot password ───────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 600),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.forgotPassword),
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              // ── Login button ──────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                duration: const Duration(milliseconds: 600),
                child: CustomButton(
                  text: AppStrings.login,
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── Divider ───────────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: const OrDivider(),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── Social buttons ────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 900),
                duration: const Duration(milliseconds: 600),
                child: Row(
                  children: [
                    Expanded(
                      child: SocialLoginButton(
                        label: AppStrings.google,
                        icon: Icons.g_mobiledata_rounded,
                        iconColor: Colors.red,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: SocialLoginButton(
                        label: AppStrings.apple,
                        icon: Icons.apple_rounded,
                        iconColor: isDark ? Colors.white : Colors.black,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              FadeInUp(
                delay: const Duration(milliseconds: 1000),
                duration: const Duration(milliseconds: 600),
                child: SocialLoginButton(
                  label: AppStrings.facebook,
                  icon: Icons.facebook_rounded,
                  iconColor: const Color(0xFF1877F2),
                  onPressed: () {},
                ),
              ),

              const SizedBox(height: AppSizes.xl),

              // ── Navigate to Sign Up ───────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 1100),
                duration: const Duration(milliseconds: 600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          AppPageTransitions.slideRight(const SignUpScreen()),
                        );
                      },
                      child: Text(
                        AppStrings.signUp,
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
