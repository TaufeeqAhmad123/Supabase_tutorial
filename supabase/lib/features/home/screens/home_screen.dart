import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/core/constants/app_colors.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/auth/provider/note_provider.dart';
import 'package:supabase_basic/features/home/screens/profile_screen.dart';
import 'package:supabase_basic/features/home/widget/notes_list.dart';
import 'package:supabase_basic/features/home/widget/show_note_dialog.dart';
import 'package:supabase_basic/model/note_model.dart';

/// Home screen with a notes list and a FAB that opens
/// a dialog to add new notes, displayed on the UI.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch the user's profile on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.currentUserId;
      if (userId != null) {
        authProvider.getProfile(userId);
      }
    });
  }

  // ── Show Add Note Dialog ─────────────────────────────────
  void _showAddNoteDialog() {
    showNoteDialog(
      context: context,
      dialogTitle: 'New Note',
      dialogIcon: Iconsax.note_add,
      buttonLabel: 'Save Note',
      buttonIcon: Iconsax.add_circle,
      onSave: (title, content) async {
        final noteProvider = Provider.of<NoteProvider>(context, listen: false);
        await noteProvider.addNote(
          NoteModel(title: title, content: content, createdAt: DateTime.now()),
        );
      },
    );
  }

  // ── Show Edit Note Dialog ────────────────────────────────
  void _showEditNoteDialog({
    required dynamic noteId,
    required String currentTitle,
    required String currentContent,
  }) {
    showNoteDialog(
      context: context,
      dialogTitle: 'Edit Note',
      dialogIcon: Iconsax.edit,
      initialTitle: currentTitle,
      initialContent: currentContent,
      buttonLabel: 'Update Note',
      buttonIcon: Iconsax.tick_circle,
      onSave: (title, content) async {
        final noteProvider = Provider.of<NoteProvider>(context, listen: false);
        await noteProvider.updateNote(
          NoteModel(
            id: noteId,
            title: title,
            content: content,
            createdAt: DateTime.now(),
          ),
          noteId.toString(),
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
          // ── Profile Avatar ────────────────────────────
          FadeInDown(
            delay: const Duration(milliseconds: 300),
            duration: const Duration(milliseconds: 500),
            child: Padding(
              padding: const EdgeInsets.only(right: AppSizes.sm),
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final profile = authProvider.currentProfile;
                  final name = profile?.full_name ?? 'U';
                  final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: (profile != null && profile.avatar_url.isNotEmpty)
                      ?CircleAvatar(
                        backgroundImage: NetworkImage(profile.avatar_url),
                      )
                      :Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      // ── Body ────────────────────────────────────────────
      body: NotesList(
        onEditNote:
            ({
              required noteId,
              required currentTitle,
              required currentContent,
            }) {
              _showEditNoteDialog(
                noteId: noteId,
                currentTitle: currentTitle,
                currentContent: currentContent,
              );
            },
      ),

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
}
