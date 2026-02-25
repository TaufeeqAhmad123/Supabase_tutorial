import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A simple Note model.
class _Note {
  final String title;
  final String content;
  final DateTime createdAt;
  final Color color;

  _Note({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.color,
  });
}

/// Home screen with a notes list and a FAB that opens
/// a dialog to add new notes, displayed on the UI.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<_Note> _notes = [];
  final titleController = TextEditingController();
  final contentController = TextEditingController();
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

  void _showAddNoteDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Note',
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
                  // ── Dialog header ───────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMd,
                          ),
                        ),
                        child: const Icon(
                          Iconsax.note_add,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: AppSizes.md),
                      Text(
                        'New Note',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
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
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // ── Title field ─────────────────────────────
                  TextField(
                    controller: titleController,
                    style: Theme.of(context).textTheme.titleLarge,
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: 'Note title',
                      prefixIcon: const Icon(Iconsax.text, size: 20),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.cardDark
                          : AppColors.scaffoldLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.inputBorderDark
                              : AppColors.inputBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.inputBorderDark
                              : AppColors.inputBorder,
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
                  ),

                  const SizedBox(height: AppSizes.md),

                  // ── Content field ───────────────────────────
                  TextField(
                    controller: contentController,
                    maxLines: 4,
                    style: Theme.of(context).textTheme.bodyLarge,
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: 'Write your note here...',
                      alignLabelWithHint: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Icon(Iconsax.edit_2, size: 20),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.cardDark
                          : AppColors.scaffoldLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.inputBorderDark
                              : AppColors.inputBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.inputBorderDark
                              : AppColors.inputBorder,
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
                  ),

                  const SizedBox(height: AppSizes.lg),

                  // ── Save button ─────────────────────────────
                  SizedBox(
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
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusLg,
                          ),
                        ),
                        onPressed: () {
                          final title = titleController.text.trim();
                          final content = contentController.text.trim();
                          if (title.isEmpty && content.isEmpty) return;

                          addNotes();
                          Navigator.pop(context);
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.add_circle,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: AppSizes.sm),
                            Text(
                              'Save Note',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void addNotes() async {
    await Supabase.instance.client.from('Notes').insert({
      'body': contentController.text.trim(),
    });
  }

  final _noteStream = Supabase.instance.client
      .from('Notes')
      .stream(primaryKey: ['id']);

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
                onPressed: () {},
                icon: const Icon(Iconsax.setting_2, size: 22),
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
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _noteStream,
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
            final body = noteData['body'] as String? ?? '';
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final color = isDark
                ? _cardColorsDark[index % _cardColorsDark.length]
                : _cardColors[index % _cardColors.length];

            return FadeInUp(
              delay: Duration(milliseconds: 80 * index),
              duration: const Duration(milliseconds: 500),
              child: _NoteCard(
                body: body,
                color: color,
                createdAt:
                    DateTime.tryParse(
                      noteData['created_at']?.toString() ?? '',
                    ) ??
                    DateTime.now(),
                onDelete: () async {
                  final id = noteData['id'];
                  if (id != null) {
                    await Supabase.instance.client
                        .from('Notes')
                        .delete()
                        .eq('id', id);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}

/// A premium-styled note card.
class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.body,
    required this.color,
    required this.createdAt,
    required this.onDelete,
  });

  final String body;
  final Color color;
  final DateTime createdAt;
  final VoidCallback onDelete;

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
                // ── Body row ──────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        body,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimaryLight,
                              height: 1.5,
                            ),
                        maxLines: 4,
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
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      ),
                      onSelected: (value) {
                        if (value == 'delete') onDelete();
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.trash,
                                size: 18,
                                color: AppColors.error,
                              ),
                              SizedBox(width: AppSizes.sm),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.sm),

                // ── Timestamp ─────────────────────────────
                Row(
                  children: [
                    Icon(
                      Iconsax.clock,
                      size: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark.withValues(alpha: 0.6)
                          : AppColors.textSecondaryLight.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeAgo,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark.withValues(alpha: 0.6)
                            : AppColors.textSecondaryLight.withValues(
                                alpha: 0.6,
                              ),
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
