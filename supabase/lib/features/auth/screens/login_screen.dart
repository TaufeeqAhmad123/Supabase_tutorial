import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/core/constants/app_strings.dart';
import 'package:supabase_basic/core/theme/page_transitions.dart';
import 'package:supabase_basic/core/widgets/auth_header.dart';
import 'package:supabase_basic/core/widgets/custom_button.dart'
    show CustomButton;
import 'package:supabase_basic/core/widgets/custom_text_field.dart';
import 'package:supabase_basic/core/widgets/or_divider.dart';
import 'package:supabase_basic/core/widgets/social_login_button.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/auth/provider/login_provider.dart';
import 'package:supabase_basic/features/auth/screens/welcome_screen.dart';
import 'signup_screen.dart';

/// Login screen — pure UI, all logic lives in LoginProvider.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

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
                child: Consumer<LoginProvider>(
                  builder: (context, loginProv, _) {
                    return CustomTextField(
                      hintText: AppStrings.email,
                      prefixIcon: Iconsax.sms,
                      keyboardType: TextInputType.emailAddress,
                      controller: loginProv.emailController,
                      textInputAction: TextInputAction.next,
                      errorText: loginProv.emailError,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.md),

              // ── Password field ────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: Consumer<LoginProvider>(
                  builder: (context, loginProv, _) {
                    return CustomTextField(
                      hintText: AppStrings.password,
                      prefixIcon: Iconsax.lock,
                      isPassword: true,
                      controller: loginProv.passwordController,
                      textInputAction: TextInputAction.done,
                      errorText: loginProv.passwordError,
                    );
                  },
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
                child: Consumer<LoginProvider>(
                  builder: (context, loginProv, _) {
                    return CustomButton(
                      text: AppStrings.login,
                      onPressed: () async {
                        final success = await loginProv.handleLogin(
                          authProvider,
                        );
                        if (!success && context.mounted) {
                          if (loginProv.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(loginProv.errorMessage!)),
                            );
                          }
                        }
                        // On success, AuthGate stream navigates to HomeScreen
                      },
                      isLoading: loginProv.isLoading,
                    );
                  },
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
                        onPressed: () => authProvider.signInWithGoogle(),
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
                  onPressed: () {
                    authProvider.signInWithFacebook();
                  },
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
