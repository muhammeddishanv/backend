import 'package:get/get.dart';

import '../controllers/admin_create_lesson_controller.dart';

class AdminCreateLessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCreateLessonController>(
      () => AdminCreateLessonController(),
    );
  }
}
