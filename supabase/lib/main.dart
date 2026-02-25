import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_basic/core/constants/api_key.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';

/// Entry point of the Luxe app — premium Flutter UI showcase.
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: ApiKey.supabaseUrl,
    anonKey: ApiKey.supabaseAnonKey,
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
    return MaterialApp(
      title: 'Luxe',
      debugShowCheckedModeBanner: false,

      // ── Themes ──────────────────────────────────────────
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Follows device setting
      // ── Start screen ────────────────────────────────────
      home: const SplashScreen(),
    );
  }
}
