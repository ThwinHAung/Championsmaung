// route_guard.dart
import 'package:champion_maung/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

class RouteGuard extends StatelessWidget with WidgetsBindingObserver {
  final Widget child;
  final AuthService authService;

  RouteGuard({required this.child, required this.authService});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        } else if (snapshot.hasData && snapshot.data == true) {
          return child; // The protected route's page
        } else {
          return LoginScreen(); // Redirect to login if not authenticated
        }
      },
    );
  }
}
