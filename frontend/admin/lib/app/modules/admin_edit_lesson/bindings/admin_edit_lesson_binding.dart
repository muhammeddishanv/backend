// Binding for the Admin Edit Lesson module.
// Purpose: register module-level dependencies when the route is opened.
// This uses Get.lazyPut so the controller is created on first use and
// disposed automatically when not needed.
import 'package:get/get.dart';

import '../controllers/admin_edit_lesson_controller.dart';

class AdminEditLessonBinding extends Bindings {
  @override
  void dependencies() {
    // Controller lifecycle is managed by GetX. No other services required here.
    Get.lazyPut<AdminEditLessonController>(() => AdminEditLessonController());
  }
}
