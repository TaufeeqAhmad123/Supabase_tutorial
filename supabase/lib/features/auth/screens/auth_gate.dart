import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/auth/screens/login_screen.dart';
import 'package:supabase_basic/features/home/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
