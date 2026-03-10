import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_basic/features/auth/provider/auth_provider.dart';
import 'package:supabase_basic/features/auth/screens/admin.dart';
import 'package:supabase_basic/features/auth/screens/auth_method_screen.dart';
import 'package:supabase_basic/features/home/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isRoleFetching = false;

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
          final user = snapshot.data!;

          // If the role hasn't been loaded yet (e.g. after hot restart),
          // fetch it and show a loader while waiting.
          if (authProvider.userRole == null && !_isRoleFetching) {
            _isRoleFetching = true;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await authProvider.getUserRole(user.id);
              if (mounted) {
                setState(() => _isRoleFetching = false);
              }
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Still fetching the role
          if (_isRoleFetching) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Route based on user role
          if (authProvider.userRole == 'admin') {
            return const AdminScreen();
          }
          return const HomeScreen();
        } else {
          // User logged out — reset the flag for next login
          _isRoleFetching = false;
          return const AuthMethodScreen();
        }
      },
    );
  }
}
