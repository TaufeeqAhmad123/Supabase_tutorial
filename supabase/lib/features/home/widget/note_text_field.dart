import 'package:flutter/material.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';

/// Reusable styled text field for note dialogs.
class NoteTextField extends StatelessWidget {
  const NoteTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.maxLines = 1,
    this.alignIconTop = false,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final int maxLines;
  final bool alignIconTop;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: maxLines == 1
          ? Theme.of(context).textTheme.titleLarge
          : Theme.of(context).textTheme.bodyLarge,
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: hintText,
        alignLabelWithHint: alignIconTop,
        prefixIcon: alignIconTop
            ? Padding(
                padding: EdgeInsets.only(bottom: (maxLines - 1) * 20.0),
                child: Icon(prefixIcon, size: 20),
              )
            : Icon(prefixIcon, size: 20),
        filled: true,
        fillColor: isDark ? AppColors.cardDark : AppColors.scaffoldLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(
            color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
