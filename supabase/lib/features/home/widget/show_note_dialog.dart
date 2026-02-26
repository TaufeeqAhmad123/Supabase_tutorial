import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/features/home/widget/dialog_header.dart';
import 'package:supabase_basic/features/home/widget/gradient_button.dart';
import 'package:supabase_basic/features/home/widget/note_text_field.dart';

/// Shows a premium animated dialog for creating or editing a note.
///
/// Usage:
/// ```dart
/// showNoteDialog(
///   context: context,
///   dialogTitle: 'New Note',
///   onSave: (title, content) async { ... },
/// );
/// ```
void showNoteDialog({
  required BuildContext context,
  String? dialogTitle,
  IconData? dialogIcon,
  String? initialTitle,
  String? initialContent,
  String? buttonLabel,
  IconData? buttonIcon,
  required Future<void> Function(String title, String content) onSave,
}) {
  final titleCtrl = TextEditingController(text: initialTitle ?? '');
  final contentCtrl = TextEditingController(text: initialContent ?? '');

  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: dialogTitle ?? 'Note',
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (context, anim1, anim2, child) {
      final curved = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      final isDark = Theme.of(context).brightness == Brightness.dark;

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.88,
            padding: const EdgeInsets.all(AppSizes.lg),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Dialog header ─────────────────────────
                DialogHeader(
                  icon: dialogIcon ?? Iconsax.note_add,
                  title: dialogTitle ?? 'New Note',
                ),

                const SizedBox(height: AppSizes.lg),

                // ── Title field ───────────────────────────
                NoteTextField(
                  controller: titleCtrl,
                  hintText: 'Note title',
                  prefixIcon: Iconsax.text,
                  maxLines: 1,
                ),

                const SizedBox(height: AppSizes.md),

                // ── Content field ─────────────────────────
                NoteTextField(
                  controller: contentCtrl,
                  hintText: 'Write your note here...',
                  prefixIcon: Iconsax.edit_2,
                  maxLines: 4,
                  alignIconTop: true,
                ),

                const SizedBox(height: AppSizes.lg),

                // ── Action button ─────────────────────────
                GradientButton(
                  icon: buttonIcon ?? Iconsax.add_circle,
                  label: buttonLabel ?? 'Save Note',
                  onPressed: () async {
                    final title = titleCtrl.text.trim();
                    final content = contentCtrl.text.trim();
                    if (title.isEmpty && content.isEmpty) return;

                    await onSave(title, content);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
