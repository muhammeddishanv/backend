// Flutter and GetX imports used by the admin application.
// - flutter/foundation: provides basic utilities like kDebugMode
// - flutter/material: Material design widgets and theming
// - get: GetX package for routing, state management, and dependency injection
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// App-specific modules:
// - app_theme: defines light/dark ThemeData used by the app
// - app_bindings: initial dependency bindings (GetX) for the app
// - app_pages: route definitions and unknown-route handling
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_bindings.dart';
import 'app/routes/app_pages.dart';

void main() {
  // Ensure Flutter binding is initialized before running the app. This is
  // required when code needs to interact with the engine before runApp
  // (for example: plugin initialization, platform channels, etc.).
  WidgetsFlutterBinding.ensureInitialized();

  // Start the Flutter application. The `MyApp` widget configures global
  // settings (routing, theme, bindings) via GetMaterialApp below.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EdTech',
      // Routing configuration
      initialRoute: AppPages.INITIAL, // starting route when app launches
      getPages: AppPages.routes, // list of GetPage route definitions
      unknownRoute: AppPages.unknownRoute, // fallback for unknown paths
      // Theming
      theme: lightTheme, // light theme defined in `app_theme.dart`
      darkTheme: darkTheme, // dark theme variant
      themeMode: ThemeMode.light, // default to light mode (can be switched)
      // Dependency injection / bindings
      initialBinding:
          InitialBindings(), // registers controllers/services on startup
      // Debug & UI behavior
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      popGesture: true, // enable iOS-style back-swipe gesture where supported
      // Logging: enable GetX internal logs in debug mode, and route logs to
      // debugPrint so logs show in the console during development.
      enableLog: kDebugMode,
      logWriterCallback: (String log, {bool? isError}) => debugPrint(log),

      // Navigator observers can be added to observe route changes; left empty
      // here but kept for clarity and future extension.
      navigatorObservers: [],
    );
  }
}
