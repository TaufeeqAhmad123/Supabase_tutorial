import 'package:supabase_basic/model/note_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> addNote(NoteModel note) async {
    try {
      await _supabase.from('Notes').insert(note.toMap());
    } catch (e) {
      throw e;
    }
  }

  Stream<List<NoteModel>> get stream => _supabase
      .from('Notes')
      .stream(primaryKey: ['id'])
      .map((data) => data.map((e) => NoteModel.fromMap(e)).toList());

  Future<void> updateNote(NoteModel note,String content) async {
    try {
      await _supabase.from('Notes').update({'content':content}).eq('id', note.id as Object);
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await _supabase.from('Notes').delete().eq('id', id);
    } catch (e) {
      throw e;
    }
  }
}
