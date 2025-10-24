import 'package:get/get.dart';

import '../controllers/admin_create_lesson_controller.dart';

// Binding for the Create Lesson module.
// GetX Bindings provide a place to register controllers and dependencies
// scoped to a specific route. Here we lazily create the
// AdminCreateLessonController when the route is navigated to.
class AdminCreateLessonBinding extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut so the controller is only instantiated when needed.
    Get.lazyPut<AdminCreateLessonController>(
      () => AdminCreateLessonController(),
    );
  }
}
