import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/core/constants/app_sizes.dart';
import 'package:supabase_basic/features/auth/provider/note_provider.dart';
import 'package:supabase_basic/features/home/widget/empty_state.dart';
import 'package:supabase_basic/features/home/widget/note_card.dart';
import 'package:supabase_basic/model/note_model.dart';

/// Notes list — a staggered card layout with real-time stream from Supabase.
class NotesList extends StatelessWidget {
  const NotesList({
    super.key,
    required this.onEditNote,
  });

  /// Callback triggered when the user taps "Update" on a note card.
  final void Function({
    required dynamic noteId,
    required String currentTitle,
    required String currentContent,
  }) onEditNote;

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

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: false);

    return StreamBuilder<List<NoteModel>>(
      stream: noteProvider.notesStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data!;

        if (notes.isEmpty) {
          return const EmptyState();
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
              child: NoteCard(
                title: noteData.title,
                content: noteData.content,
                color: color,
                createdAt: DateTime.tryParse(
                      noteData.createdAt.toString(),
                    ) ??
                    DateTime.now(),
                onDelete: () async {
                  final id = noteData.id;
                  if (id != null) {
                    await noteProvider.deleteNote(id.toString());
                  }
                },
                onUpdate: () {
                  onEditNote(
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
