import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService{
  final SupabaseClient _supabase=Supabase.instance.client;

  
  //sign in with email and password
  Future<AuthResponse> signInWithEmailAndPassword(String email,String password)async{
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  //sign up with email and password
  Future<AuthResponse> createAccountWithEmailAndPassword(String email,String password)async{
    return await _supabase.auth.signUp(email: email, password: password);
  }

  //sign out
  Future<void> signOut()async{
    await _supabase.auth.signOut();
  }

  //get current user
  String? getCurrentUser(){
    final session=_supabase.auth.currentSession;
    final user=session?.user;
    return user?.email;
  }

  //listen to auth changes
  Stream<User?> get authStateChanges => _supabase.auth.onAuthStateChange.map((event) => event.session?.user);
}