import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/auth/screens/auth_method_screen.dart';
import 'package:supabase_basic/features/home/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      // Seed with the current session user so we don't miss an already-emitted event
      initialData: authProvider.currentSessionUser,
      builder: (context, snapshot) {
        // Only show loader on the very first connection, not on every rebuild
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const AuthMethodScreen();
        }
      },
    );
  }
}
