import 'package:get/get.dart';

import 'lesson.controller.dart';

class LessonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LessonController>(
      () => LessonController(),
    );
  }
}
