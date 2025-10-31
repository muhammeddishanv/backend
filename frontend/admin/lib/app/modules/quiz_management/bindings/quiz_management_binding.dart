import 'package:get/get.dart';

import '../controllers/quiz_management_controller.dart';

class QuizManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizManagementController>(
      () => QuizManagementController(),
    );
  }
}
