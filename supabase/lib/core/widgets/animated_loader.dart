import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A smooth animated loader — a triple-dot pulsing indicator
/// that can be embedded anywhere (e.g. inside a button or page).
class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({super.key, this.color, this.size = 10});

  final Color? color;
  final double size;

  @override
  State<AnimatedLoader> createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Each dot is offset in phase by 0.2
            final phase = (_controller.value + index * 0.2) % 1.0;
            final scale = 0.5 + 0.5 * _bounce(phase);
            final opacity = 0.4 + 0.6 * _bounce(phase);
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.size * 0.3),
              width: widget.size * scale,
              height: widget.size * scale,
              decoration: BoxDecoration(
                color: color.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }

  /// Simple bounce curve for the dots.
  double _bounce(double t) {
    if (t < 0.5) return 4 * t * t * (3 - 4 * t);
    return 1 - 4 * (t - 0.5) * (t - 0.5) * (3 - 4 * (t - 0.5));
  }
}

/// Minimal animated builder helper.
class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) => builder(context, child);
}
