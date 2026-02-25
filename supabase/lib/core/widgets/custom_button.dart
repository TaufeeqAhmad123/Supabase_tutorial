import 'package:flutter/material.dart';
import 'package:supabase/core/constants/app_colors.dart';
import 'package:supabase/core/constants/app_sizes.dart';

/// A premium, customizable button supporting:
/// - **primary** – filled gradient / solid primary color
/// - **secondary** – outlined style
/// - **disabled** state
/// - loading state with a circular spinner
/// - optional leading / trailing icons
class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.trailingIcon,
    this.height,
    this.width,
    this.borderRadius,
    this.gradient,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final IconData? trailingIcon;
  final double? height;
  final double? width;
  final double? borderRadius;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _enabled => !widget.isDisabled && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? AppSizes.radiusLg;
    final height = widget.height ?? AppSizes.buttonHeight;

    return GestureDetector(
      onTapDown: _enabled ? (_) => _controller.forward() : null,
      onTapUp: _enabled ? (_) => _controller.reverse() : null,
      onTapCancel: _enabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: widget.isPrimary
            ? _buildPrimary(context, radius, height)
            : _buildSecondary(context, radius, height),
      ),
    );
  }

  Widget _buildPrimary(BuildContext context, double radius, double height) {
    return Container(
      width: widget.width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: widget.isDisabled
            ? null
            : (widget.gradient ?? AppColors.primaryGradient),
        color: widget.isDisabled ? Colors.grey.shade300 : null,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: widget.isDisabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _enabled ? widget.onPressed : null,
          borderRadius: BorderRadius.circular(radius),
          splashColor: Colors.white.withValues(alpha: 0.15),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Center(child: _buildContent(Colors.white)),
        ),
      ),
    );
  }

  Widget _buildSecondary(BuildContext context, double radius, double height) {
    return Container(
      width: widget.width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: widget.isDisabled
              ? Colors.grey.shade300
              : (widget.backgroundColor ?? AppColors.primary),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _enabled ? widget.onPressed : null,
          borderRadius: BorderRadius.circular(radius),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          child: Center(
            child: _buildContent(
              widget.isDisabled
                  ? Colors.grey
                  : (widget.foregroundColor ?? AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color color) {
    if (widget.isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 20, color: color),
          const SizedBox(width: AppSizes.sm),
        ],
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: AppSizes.sm),
          Icon(widget.trailingIcon, size: 20, color: color),
        ],
      ],
    );
  }
}
