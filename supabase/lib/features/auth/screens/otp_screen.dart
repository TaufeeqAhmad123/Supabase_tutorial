import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/core/constants/app_strings.dart';
import 'package:supabase_basic/core/utils/app_snackbar.dart';
import 'package:supabase_basic/core/widgets/custom_button.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/auth/provider/phone_auth_provider.dart';

/// OTP verification screen — user enters the 6-digit code sent to their phone.
class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final phoneProv = Provider.of<PhoneAuthProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

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

              const SizedBox(height: AppSizes.lg),

              // ── Header Illustration ───────────────────────
              FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent.withValues(
                          alpha: isDark ? 0.25 : 0.12,
                        ),
                        AppColors.primary.withValues(
                          alpha: isDark ? 0.15 : 0.06,
                        ),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Iconsax.shield_tick,
                    size: 52,
                    color: AppColors.accent,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── Title ─────────────────────────────────────
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 600),
                child: Text(
                  AppStrings.verifyPhone,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSizes.sm),

              // ── Subtitle with phone number ────────────────
              FadeInDown(
                delay: const Duration(milliseconds: 350),
                duration: const Duration(milliseconds: 600),
                child: Text.rich(
                  TextSpan(
                    text: '${AppStrings.otpSubtitle}\n',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                    children: [
                      TextSpan(
                        text: phoneProv.phoneNumber,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSizes.xxl),

              // ── OTP Input Fields ──────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                duration: const Duration(milliseconds: 600),
                child: _OtpInputRow(controller: phoneProv.otpController),
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

              // ── Verify button ─────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 650),
                duration: const Duration(milliseconds: 600),
                child: CustomButton(
                  text: AppStrings.verifyCode,
                  icon: Iconsax.shield_tick,
                  isLoading: phoneProv.isLoading,
                  onPressed: () async {
                    final success = await phoneProv.verifyOtp(authProvider);
                    if (success && context.mounted) {
                      AppSnackbar.success(
                        context,
                        message: 'Phone verified successfully! \u{1F389}',
                      );
                      // Pop all the way back to AuthGate
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    } else if (!success && context.mounted) {
                      if (phoneProv.errorMessage != null) {
                        AppSnackbar.error(
                          context,
                          message: phoneProv.errorMessage!,
                        );
                      }
                    }
                  },
                ),
              ),

              const SizedBox(height: AppSizes.lg),

              // ── Resend code ───────────────────────────────
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                duration: const Duration(milliseconds: 600),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.didntGetCode,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    phoneProv.canResend
                        ? GestureDetector(
                            onTap: () async {
                              await phoneProv.resendOtp();
                              if (context.mounted) {
                                AppSnackbar.info(
                                  context,
                                  message:
                                      'OTP resent to ${phoneProv.phoneNumber}',
                                );
                              }
                            },
                            child: Text(
                              AppStrings.resendCode,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          )
                        : Text(
                            '${AppStrings.resendIn} ${phoneProv.resendSeconds}s',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
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

/// A row of 6 styled OTP digit boxes that auto-focus forward.
class _OtpInputRow extends StatefulWidget {
  const _OtpInputRow({required this.controller});
  final TextEditingController controller;

  @override
  State<_OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<_OtpInputRow> {
  final List<TextEditingController> _digitControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Sync individual digit controllers → parent controller
    for (int i = 0; i < 6; i++) {
      _digitControllers[i].addListener(_syncParent);
    }
  }

  void _syncParent() {
    widget.controller.text = _digitControllers.map((c) => c.text).join();
  }

  @override
  void dispose() {
    for (final c in _digitControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (i) {
        return SizedBox(
          width: 48,
          height: 56,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              border: Border.all(
                color: _focusNodes[i].hasFocus
                    ? AppColors.primary
                    : (isDark
                          ? AppColors.inputBorderDark
                          : AppColors.inputBorder),
                width: _focusNodes[i].hasFocus ? 2 : 1,
              ),
              boxShadow: _focusNodes[i].hasFocus
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: TextField(
                controller: _digitControllers[i],
                focusNode: _focusNodes[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  setState(() {}); // Rebuild for border updates
                  if (value.isNotEmpty && i < 5) {
                    _focusNodes[i + 1].requestFocus();
                  }
                  if (value.isEmpty && i > 0) {
                    _focusNodes[i - 1].requestFocus();
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
