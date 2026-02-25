import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/core/constants/app_strings.dart';
import 'package:supabase_basic/core/theme/page_transitions.dart';
import 'package:supabase_basic/core/widgets/custom_button.dart';

import 'login_screen.dart';

/// Data model for a single onboarding page.
class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
  });
}

/// 3-page onboarding flow with smooth transitions and page indicator.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPageData(
      icon: Iconsax.discover_1,
      title: AppStrings.onboardingTitle1,
      subtitle: AppStrings.onboardingSubtitle1,
      accentColor: AppColors.primary,
    ),
    _OnboardingPageData(
      icon: Iconsax.people,
      title: AppStrings.onboardingTitle2,
      subtitle: AppStrings.onboardingSubtitle2,
      accentColor: AppColors.accent,
    ),
    _OnboardingPageData(
      icon: Iconsax.chart_2,
      title: AppStrings.onboardingTitle3,
      subtitle: AppStrings.onboardingSubtitle3,
      accentColor: Color(0xFFFF6B6B),
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  void _onNext() {
    if (_isLastPage) {
      _navigateToLogin();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _navigateToLogin() {
    Navigator.of(
      context,
    ).pushReplacement(AppPageTransitions.fadeSlide(const LoginScreen()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Skip button ─────────────────────────────────
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppSizes.md,
                  right: AppSizes.md,
                ),
                child: AnimatedOpacity(
                  opacity: _isLastPage ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: TextButton(
                    onPressed: _isLastPage ? null : _navigateToLogin,
                    child: Text(
                      AppStrings.skip,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Page view ───────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  return _OnboardingPage(data: _pages[index]);
                },
              ),
            ),

            // ── Indicator + button ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.lg,
                0,
                AppSizes.lg,
                AppSizes.xxl,
              ),
              child: Column(
                children: [
                  // Smooth dot indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColors.primary,
                      dotColor: isDark
                          ? AppColors.dividerDark
                          : AppColors.divider,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                      spacing: 6,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xl),

                  // Next / Get Started button
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: CustomButton(
                      key: ValueKey(_isLastPage),
                      text: _isLastPage
                          ? AppStrings.getStarted
                          : AppStrings.next,
                      trailingIcon: _isLastPage
                          ? null
                          : Icons.arrow_forward_rounded,
                      onPressed: _onNext,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single onboarding page with illustration, title, subtitle.
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Illustration placeholder ──────────────────────
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Container(
              width: AppSizes.illustrationSize,
              height: AppSizes.illustrationSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    data.accentColor.withValues(alpha: isDark ? 0.25 : 0.12),
                    data.accentColor.withValues(alpha: isDark ? 0.08 : 0.03),
                  ],
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer ring
                  Container(
                    width: AppSizes.illustrationSize * 0.75,
                    height: AppSizes.illustrationSize * 0.75,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: data.accentColor.withValues(alpha: 0.15),
                        width: 2,
                      ),
                    ),
                  ),
                  Icon(data.icon, size: 72, color: data.accentColor),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSizes.xxl),

          // ── Title ─────────────────────────────────────────
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 600),
            child: Text(
              data.title,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSizes.md),

          // ── Subtitle ──────────────────────────────────────
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 600),
            child: Text(
              data.subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
