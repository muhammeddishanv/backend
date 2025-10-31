import 'package:get/get.dart';

import '../controllers/admin_lesson_management_controller.dart';

class AdminLessonManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminLessonManagementController>(
      () => AdminLessonManagementController(),
    );
  }
}
