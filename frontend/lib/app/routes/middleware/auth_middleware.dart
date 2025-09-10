import 'package:flutter/widgets.dart';

import 'package:get/get.dart';

import 'package:ed_tech/app/data/services/auth_service.dart';
import 'package:ed_tech/app/routes/app_pages.dart';

/*
  This middleware checks if the user is authenticated before allowing access to certain routes.
  it redirects unauthenticated users to the login page.

  created by : Muhammed Shabeer OP
  date : 2025-08-10
  updated date : 2025-08-10
 */

class AuthMiddleware extends GetMiddleware {
  // Lower value = higher priority (optional but explicit)
  @override
  int? priority = 1;

  @override
  RouteSettings? redirect(String? route) {
    // Ensure the service is registered to avoid runtime errors
    if (!Get.isRegistered<AuthService>()) {
      // If targeting auth already, allow it; otherwise, send to auth
      return route == Routes.AUTH
          ? null
          : const RouteSettings(name: Routes.AUTH);
    }

    final authService = Get.find<AuthService>();
    final bool loggedIn = authService.isLoggedIn.value;

    debugPrint('AuthMiddleware: Checking authentication status: $loggedIn');

    // If not logged in and not already on auth route, redirect to auth
    if (!loggedIn && route != Routes.AUTH) {
      return const RouteSettings(name: Routes.AUTH);
    }

    // If logged in and trying to go to auth route, redirect to home (adjust target as needed)
    if (loggedIn && route == Routes.AUTH) {
      return const RouteSettings(name: Routes.HOME);
    }

    return null; // Allow navigation
  }
}
