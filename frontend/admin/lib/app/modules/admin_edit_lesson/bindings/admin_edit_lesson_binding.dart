import 'package:get/get.dart';

import '../controllers/admin_edit_lesson_controller.dart';

class AdminEditLessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminEditLessonController>(
      () => AdminEditLessonController(),
    );
  }
}
