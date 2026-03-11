import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:supabase_basic/model/model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? get user => _supabase.auth.currentUser;
  String get email => _supabase.auth.currentUser!.email!;
  // ScreenRedirect(User user)async{
  //   if(user !=null){
  //     if(user.emailConfirmedAt!=null){
  //       return HomeScreen();
  //     }else{
  //       return EmailVerificationScreen();
  //     }
  //   }
  //   return LoginScreen();
  // }

  // ── Email/Password Auth ─────────────────────────────────
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> createAccountWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  // ── Google Sign-In ──────────────────────────────────────
  Future<void> signInWithGoogle() async {
    try {
      final googleAccount = await GoogleSignIn.instance.authenticate();
      final idToken = googleAccount.authentication.idToken ?? '';
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

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: auth.accessToken,
      );

      final User? user = response.user;
      if (user != null) {
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
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      rethrow;
    }
  }

  // ── Facebook Sign-In ────────────────────────────────────
  Future<void> signInWithFacebook() async {
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: 'devcode://fblogin',
      queryParams: {'auth_type': 'reauthenticate'},
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
    _supabase.auth.onAuthStateChange.listen((authState) {
      if (authState.session != null) {
        final user = authState.session?.user;
        if (user != null) _saveFacebookProfile(user);
      }
    });
  }

  void _saveFacebookProfile(User user) {
    final metadata = user.userMetadata ?? {};
    final email = user.email ?? '';
    final name = metadata['full_name'] ?? '';
    final avatar = metadata['avatar_url'] ?? '';

    if (email.isNotEmpty) {
      createProfile(name, email, avatar, 'facebook');
    }
  }

  // ── Phone OTP Auth ──────────────────────────────────────
  Future<void> signInWithPhone(String phoneNumber) async {
    await _supabase.auth.signInWithOtp(phone: phoneNumber);
  }

  Future<AuthResponse> verifyPhoneOtp(String phone, String otpCode) async {
    final response = await _supabase.auth.verifyOTP(
      phone: phone,
      token: otpCode,
      type: OtpType.sms,
    );
    final User? user = response.user;
    if (user != null) {
      final existingProfile = await getProfile(user.id);
      if (existingProfile == null) {
        await createProfile(
          user.userMetadata?['full_name'] ?? '',
          user.email ?? '',
          user.userMetadata?['avatar_url'] ?? '',
          'phone',
        );
      }
    }
    return response;
  }

  // ── Profile Management ──────────────────────────────────
  Future<Profile> createProfile(
    String name,
    String email,
    String avatarUrl,
    String provider,
  ) async {
    if (user == null) throw AuthException('User not found');

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

    await _supabase.from('profiles').upsert(profileData);
    return Profile.fromJson(profileData);
  }

  Future<Profile?> getProfile(String id) async {
    try {
      if (user == null) throw AuthException('User not found');

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

  Future<String> getUserRole(String id)async{
    final data=await _supabase.from('profiles').select('role').eq('id', id).maybeSingle();
    if(data==null){
      throw AuthException('User not found');
    }
    return data['role'] ?? 'user';
  }

  /// Uploads a profile image to Supabase Storage and updates the profile's avatar_url.
  /// Returns the public URL of the uploaded image.
  Future<String> setProfileImage(File file) async {
    if (user == null) throw AuthException('User not found');

    final ext = file.path.split('.').last;
    final fileName = '${user!.id}_${DateTime.now().millisecondsSinceEpoch}.$ext';

    await _supabase.storage.from('my_supabase').upload(
      fileName,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    final url = _supabase.storage.from('my_supabase').getPublicUrl(fileName);

    // Update the avatar_url in the profiles table
      await updateProfile({'avatar_url': url});

    debugPrint('Profile image uploaded: $url');
    return url;
  }
  Future<void> updateProfile(Map<String,dynamic> data)async{
   try{
    final userId=user?.id;
    if (userId == null) throw Exception('User not logged in');

    await _supabase.from('profiles').update({...data,'updated_at':DateTime.now().toIso8601String()}).eq('id', userId);
    final updatedProfile=await getProfile(userId);
    print("Profile updated successfully $updatedProfile");
   }catch(e){
    print("Profile update failed: $e");
    throw AuthException(e.toString());
   }
  }
  // ── Sign Out ────────────────────────────────────────────
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // ── Utility ─────────────────────────────────────────────
  String? getCurrentUser() => _supabase.auth.currentSession?.user.email;

  /// Cached broadcast stream so every listener shares the same subscription.
  late final Stream<User?> authStateChanges = _supabase.auth.onAuthStateChange
      .map((event) => event.session?.user)
      .asBroadcastStream();

  /// The current user from the active session (non-stream, point-in-time check).
  User? get currentSessionUser => _supabase.auth.currentSession?.user;
}
