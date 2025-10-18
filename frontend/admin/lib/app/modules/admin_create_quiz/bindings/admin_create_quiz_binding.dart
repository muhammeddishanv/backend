import 'package:get/get.dart';

import '../controllers/admin_create_quiz_controller.dart';

class AdminCreateQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCreateQuizController>(
      () => AdminCreateQuizController(),
    );
  }
}
