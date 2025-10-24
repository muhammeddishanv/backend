import 'package:get/get.dart';

// InitialBindings is executed when the application starts (see
// `initialBinding` in `main.dart`). Use this to register app-level
// controllers, services, and singletons that should live for the whole
// application lifetime.
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Example (do not uncomment here):
    // Get.put(AuthService());
    // Get.lazyPut(() => ApiClient());

    // Keep this method minimal. Prefer scoping controllers to route
    // bindings unless they truly need to be global.
  }
}
