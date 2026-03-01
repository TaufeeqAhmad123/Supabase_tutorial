import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:supabase_basic/features/home/screens/home_screen.dart';

void deepLink({required BuildContext context}) {
  final appLink = AppLinks();
  appLink.uriLinkStream.listen((uri) {
    if (uri.toString().contains('fblogin')) {
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      print(uri);
    }
  });
}
