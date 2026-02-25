import 'package:supabase_basic/model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? get user => _supabase.auth.currentUser;

  //sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //sign up with email and password
  Future<AuthResponse> createAccountWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  // Create profile and store it in Supabase
  Future<Profile> createProfile(String name, String email) async {
    if (user == null) {
      throw AuthException('User not found');
    }

    // Insert into the 'profiles' table in Supabase
    await _supabase.from('profile').insert({
      'id': user!.id,
      'email': email,
      'name': name,
    });

    return Profile(id: user!.id, email: email, name: name);
  }

  Future<Profile> getProfile() async {
    try {
      if (user == null) {
        throw AuthException('User not found');
      }

      final data = await _supabase
          .from('profile')
          .select()
          .eq('id', user!.id)
          .single();
      return Profile(id: data['id'], email: data['email'], name: data['name']);
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  //sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  //get current user
  String? getCurrentUser() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  //listen to auth changes
  Stream<User?> get authStateChanges =>
      _supabase.auth.onAuthStateChange.map((event) => event.session?.user);
}
