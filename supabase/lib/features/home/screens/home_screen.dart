import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/database/database_Service.dart';
import 'package:supabase_basic/model/note_model.dart';

/// Home screen with a notes list and a FAB that opens
/// a dialog to add new notes, displayed on the UI.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Predefined card accent colors for visual variety
  static const _cardColors = [
    Color(0xFFE8DEFF), // lavender
    Color(0xFFD4F5E9), // mint
    Color(0xFFFFE8D6), // peach
    Color(0xFFDBEDFF), // sky
    Color(0xFFFFD6E0), // rose
    Color(0xFFFFF3D6), // golden
  ];

  static const _cardColorsDark = [
    Color(0xFF2D2750), // lavender dark
    Color(0xFF1D3A2F), // mint dark
    Color(0xFF3A2D22), // peach dark
    Color(0xFF1E2D3D), // sky dark
    Color(0xFF3A222A), // rose dark
    Color(0xFF3A3422), // golden dark
  ];

  // ── Reusable: show note dialog (add or edit) ───────────
  void _showNoteDialog({
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
        final curved = CurvedAnimation(
          parent: anim1,
          curve: Curves.easeOutBack,
        );
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
                  _DialogHeader(
                    icon: dialogIcon ?? Iconsax.note_add,
                    title: dialogTitle ?? 'New Note',
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // ── Title field ───────────────────────────
                  _NoteTextField(
                    controller: titleCtrl,
                    hintText: 'Note title',
                    prefixIcon: Iconsax.text,
                    maxLines: 1,
                  ),

                  const SizedBox(height: AppSizes.md),

                  // ── Content field ─────────────────────────
                  _NoteTextField(
                    controller: contentCtrl,
                    hintText: 'Write your note here...',
                    prefixIcon: Iconsax.edit_2,
                    maxLines: 4,
                    alignIconTop: true,
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // ── Action button ─────────────────────────
                  _GradientButton(
                    icon: buttonIcon ?? Iconsax.add_circle,
                    label: buttonLabel ?? 'Save Note',
                    onPressed: () async {
                      final title = titleCtrl.text.trim();
                      final content = contentCtrl.text.trim();
                      if (title.isEmpty && content.isEmpty) return;

                      await onSave(title, content);
                      Navigator.pop(context);
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

  void _showAddNoteDialog() {
    _showNoteDialog(
      dialogTitle: 'New Note',
      dialogIcon: Iconsax.note_add,
      buttonLabel: 'Save Note',
      buttonIcon: Iconsax.add_circle,
      onSave: (title, content) async {
        await DatabaseService().addNote(
          NoteModel(title: title, content: content),
        );
      },
    );
  }

  void _showEditNoteDialog({
    required dynamic noteId,
    required String currentTitle,
    required String currentContent,
  }) {
    _showNoteDialog(
      dialogTitle: 'Edit Note',
      dialogIcon: Iconsax.edit,
      initialTitle: currentTitle,
      initialContent: currentContent,
      buttonLabel: 'Update Note',
      buttonIcon: Iconsax.tick_circle,
      onSave: (title, content) async {
        await DatabaseService().updateNote(
          NoteModel(id: noteId, title: title, content: content),
          content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── App Bar ─────────────────────────────────────────
      appBar: AppBar(
        title: FadeInDown(
          duration: const Duration(milliseconds: 500),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: const Center(
                  child: Text(
                    'L',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Text(
                'My Notes',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        actions: [
          FadeInDown(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Iconsax.search_normal_1, size: 22),
            ),
          ),
          FadeInDown(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.only(right: AppSizes.sm),
              child: IconButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).signOut();
                },
                icon: const Icon(Iconsax.logout, size: 22),
              ),
            ),
          ),
        ],
      ),

      // ── Body ────────────────────────────────────────────
      body: _buildNotesList(context),

      // ── FAB ─────────────────────────────────────────────
      floatingActionButton: FadeInUp(
        delay: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 600),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _showAddNoteDialog,
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: const Icon(Iconsax.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  /// Empty state — shown when no notes exist.
  Widget _buildEmptyState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                    AppColors.accent.withValues(alpha: isDark ? 0.1 : 0.05),
                  ],
                ),
              ),
              child: Icon(
                Iconsax.note_2,
                size: 52,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSizes.lg),
            Text(
              'No Notes Yet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Tap the + button to create your first note',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  /// Notes list — a staggered card layout.
  Widget _buildNotesList(BuildContext context) {
    return StreamBuilder<List<NoteModel>>(
      stream: DatabaseService().stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data!;

        if (notes.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            AppSizes.md,
            AppSizes.md,
            100,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final noteData = notes[index];
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final color = isDark
                ? _cardColorsDark[index % _cardColorsDark.length]
                : _cardColors[index % _cardColors.length];

            return FadeInUp(
              delay: Duration(milliseconds: 80 * index),
              duration: const Duration(milliseconds: 500),
              child: _NoteCard(
                title: noteData.title,
                content: noteData.content,
                color: color,
                createdAt: DateTime.tryParse(
                      noteData.createdAt?.toString() ?? '',
                    ) ??
                    DateTime.now(),
                onDelete: () async {
                  final id = noteData.id;
                  if (id != null) {
                    await DatabaseService().deleteNote(id);
                  }
                },
                onUpdate: () {
                  _showEditNoteDialog(
                    noteId: noteData.id,
                    currentTitle: noteData.title,
                    currentContent: noteData.content,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  REUSABLE WIDGETS
// ═══════════════════════════════════════════════════════════

/// Reusable styled text field for note dialogs.
class _NoteTextField extends StatelessWidget {
  const _NoteTextField({
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
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

/// Reusable dialog header with gradient icon + title + close button.
class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: AppSizes.md),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.close_rounded,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

/// Reusable gradient action button.
class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: AppSizes.sm),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A premium-styled note card.
class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.title,
    required this.content,
    required this.color,
    required this.createdAt,
    required this.onDelete,
    required this.onUpdate,
  });

  final String title;
  final String content;
  final Color color;
  final DateTime createdAt;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeAgo = _formatTimeAgo(createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: isDark
            ? Border.all(color: AppColors.dividerDark, width: 0.5)
            : null,
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title + menu ──────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: isDark
                                      ? AppColors.textPrimaryDark
                                      : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_horiz_rounded,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        size: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      onSelected: (value) {
                        if (value == 'delete') onDelete();
                        if (value == 'update') onUpdate();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'update',
                          child: Row(
                            children: [
                              Icon(Iconsax.edit, size: 18,
                                  color: AppColors.primary),
                              SizedBox(width: AppSizes.sm),
                              Text('Update'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Iconsax.trash, size: 18,
                                  color: AppColors.error),
                              SizedBox(width: AppSizes.sm),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // ── Content ──────────────────────────────
                if (content.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          height: 1.5,
                        ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: AppSizes.sm),

                // ── Timestamp ─────────────────────────────
                Row(
                  children: [
                    Icon(
                      Iconsax.clock,
                      size: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark.withValues(alpha: 0.6)
                          : AppColors.textSecondaryLight
                              .withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeAgo,
                      style:
                          Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                        .withValues(alpha: 0.6)
                                    : AppColors.textSecondaryLight
                                        .withValues(alpha: 0.6),
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
