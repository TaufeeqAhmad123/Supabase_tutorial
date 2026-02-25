import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase/core/constants/app_colors.dart';
import 'package:supabase/core/constants/app_sizes.dart';
import 'package:supabase/core/constants/app_strings.dart';
import 'package:supabase/core/theme/page_transitions.dart';
import 'package:supabase/core/widgets/custom_button.dart';
import 'package:supabase/features/home/screens/home_screen.dart';


/// Welcome / Success screen shown after verification.
/// Features scale-in + fade confetti-like animation.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // ── Animated background gradient ──────────────────
          _AnimBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(
                        alpha: 0.06 + 0.04 * _bgController.value,
                      ),
                      isDark ? AppColors.scaffoldDark : AppColors.scaffoldLight,
                      AppColors.accent.withValues(
                        alpha: 0.04 + 0.03 * _bgController.value,
                      ),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),

          // ── Floating particles ────────────────────────────
          ...List.generate(6, (i) {
            return _AnimBuilder(
              animation: _particleController,
              builder: (context, child) {
                final progress = (_particleController.value + i * 0.15) % 1.0;
                final size = MediaQuery.of(context).size;
                return Positioned(
                  left: (size.width * (0.1 + i * 0.15)) % size.width,
                  top: size.height * (1 - progress),
                  child: Opacity(
                    opacity: (1 - progress) * 0.3,
                    child: Container(
                      width: 8 + i * 4.0,
                      height: 8 + i * 4.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i.isEven ? AppColors.primary : AppColors.accent,
                      ),
                    ),
                  ),
                );
              },
            );
          }),

          // ── Main content ──────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Success illustration ──────────────────
                  ZoomIn(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.2),
                            AppColors.primary.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.2),
                            blurRadius: 40,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.tick_circle5,
                        size: 80,
                        color: AppColors.accent,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSizes.xxl),

                  // ── Title ─────────────────────────────────
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      AppStrings.welcomeTitle,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: AppSizes.md),

                  // ── Subtitle ──────────────────────────────
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      AppStrings.welcomeSubtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        height: 1.6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ── CTA Button ────────────────────────────
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    duration: const Duration(milliseconds: 600),
                    child: CustomButton(
                      text: AppStrings.continueText,
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          AppPageTransitions.fadeSlide(const HomeScreen()),
                          (route) => false,
                        );
                      },
                      gradient: AppColors.accentGradient,
                    ),
                  ),

                  const SizedBox(height: AppSizes.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Minimal animated builder helper.
class _AnimBuilder extends AnimatedWidget {
  const _AnimBuilder({
    required Animation<double> animation,
    required this.builder,
    this.child, // ignore: unused_element_parameter
  }) : super(listenable: animation);

  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) => builder(context, child);
}
