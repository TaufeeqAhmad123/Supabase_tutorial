import 'package:flutter/material.dart';
import 'package:supabase_basic/features/database/database_Service.dart';
import 'package:supabase_basic/model/note_model.dart';

class NoteProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  // ── Loading state ────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ── Notes list ───────────────────────────────────────────
  final List<NoteModel> _notes = [];
  List<NoteModel> get notes => _notes;

  // ── Error message ────────────────────────────────────────
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ── Notes stream (real-time from Supabase) ───────────────
  Stream<List<NoteModel>> get notesStream => _databaseService.stream;

  // ── Add Note ─────────────────────────────────────────────
  Future<void> addNote(NoteModel note) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _databaseService.addNote(note);
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Add note error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Update Note ──────────────────────────────────────────
  Future<void> updateNote(NoteModel note, String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _databaseService.updateNote(note, id);
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Update note error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Delete Note ──────────────────────────────────────────
  Future<void> deleteNote(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _databaseService.deleteNote(id);
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Delete note error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
