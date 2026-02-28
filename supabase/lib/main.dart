import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/core/constants/api_key.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/auth/provider/login_provider.dart';
import 'package:supabase_basic/features/auth/provider/note_provider.dart';
import 'package:supabase_basic/features/auth/provider/signup_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';

/// Entry point of the Luxe app — premium Flutter UI showcase.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: ApiKey.supabaseUrl,
    anonKey: ApiKey.supabaseAnonKey,
  );

  await GoogleSignIn.instance.initialize(
    serverClientId:
        '95617885526-841gdvne6k4hp8ncvg1o0vs4oo5ks536.apps.googleusercontent.com',
    clientId: Platform.isAndroid
        ? '95617885526-ba36ubu0u4sdupbaqa8nvh1862h8cngb.apps.googleusercontent.com'
        : '95617885526-sb67ed09p3a5pdmsrmh9ojakcidb9727.apps.googleusercontent.com',
  );

  // Set system UI overlay style for a polished feel
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(const LuxeApp());
}

class LuxeApp extends StatelessWidget {
  const LuxeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => NoteProvider()),
      ],
      child: MaterialApp(
        title: 'Luxe',
        debugShowCheckedModeBanner: false,

        // ── Themes ──────────────────────────────────────────
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Follows device setting
        // ── Start screen ────────────────────────────────────
        home: const SplashScreen(),
      ),
    );
  }
}
