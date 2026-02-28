import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
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

  //Signinwith Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      GoogleSignIn signIn = GoogleSignIn.instance;
      // await signIn.initialize(
      //   serverClientId: dotenv.env["Web_ClintID"],
      //   clientId: Platform.isAndroid
      //       ? dotenv.env["Android_ClintID"]
      //       : dotenv.env["IOS_ClintID"],
      // );
      GoogleSignInAccount googleAccount = await signIn.authenticate();
      String idToken = googleAccount.authentication.idToken ?? '';
      final auth =
          await googleAccount.authorizationClient.authorizationForScopes([
            'email',
            'openid',
            'profile',
          ]) ??
          await googleAccount.authorizationClient.authorizeScopes([
            'email',
            'openid',
            'profile',
          ]);
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: auth?.accessToken,
      );
      final User? user = response.user;
      if (user != null) {
        await createProfile(user.email!, googleAccount.displayName ?? '');
      }
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Create profile and store it in Supabase
  Future<Profile> createProfile(String name, String email) async {
    if (user == null) {
      throw AuthException('User not found');
    }

    // Insert into the 'profiles' table in Supabase
    final data = await _supabase.from('profiles').insert({
      'id': user!.id,
      'email': email,
      'name': name,
    });

    return Profile.fromJson(data);
  }

  Future<Profile> getProfile(String id) async {
    try {
      if (user == null) {
        throw AuthException('User not found');
      }

      final data = await _supabase
          .from('profile')
          .select()
          .eq('id', id)
          .single();
      return Profile.fromJson(data);
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
