import 'package:google_sign_in/google_sign_in.dart';
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
        accessToken: auth.accessToken,
      );
      final User? user = response.user;
      if (user != null) {
        // Only create profile if it doesn't already exist
        final existingProfile = await getProfile(user.id);
        if (existingProfile == null) {
          await createProfile(
            googleAccount.displayName ?? '',
            user.email!,
            googleAccount.photoUrl ?? '',
            'google',
          );
        }
      }
      return response;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // Create profile and store it in Supabase
  Future<Profile> createProfile(
    String name,
    String email,
    String avatarUrl,
    String provider,
  ) async {
    if (user == null) {
      throw AuthException('User not found');
    }

    final now = DateTime.now().toIso8601String();

    final profileData = {
      'id': user!.id,
      'email': email,
      'full_name': name,
      'avatar_url': avatarUrl,
      'provider': provider,
      'created_at': now,
      'updated_at': now,
    };

    // Upsert into the 'profiles' table (insert or update if exists)
    await _supabase.from('profiles').upsert(profileData);
    return Profile.fromJson(profileData);
  }

  Future<Profile?> getProfile(String id) async {
    try {
      if (user == null) {
        throw AuthException('User not found');
      }

      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (data == null) return null;
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
