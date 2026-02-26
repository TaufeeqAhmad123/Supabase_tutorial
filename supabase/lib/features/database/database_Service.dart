import 'package:supabase_basic/model/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String tableName = 'Notes';

  Future<void> addNote(NoteModel note) async {
    try {
      await _supabase.from(tableName).insert(note.toInsertJson());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<NoteModel>> get stream => _supabase
      .from(tableName)
      .stream(primaryKey: ['id'])
      .map((data) => data.map((e) => NoteModel.fromMap(e)).toList());

  Future<void> updateNote(NoteModel note, String id) async {
    try {
      await _supabase.from(tableName).update(note.toUpdateJson()).eq('id', id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _supabase.from(tableName).delete().eq('id', id);
    } catch (e) {
      rethrow;
    }
  }
}
