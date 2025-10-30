import 'package:get/get.dart';

import '../controllers/admin_quiz_management_controller.dart';

class AdminQuizManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminQuizManagementController>(
      () => AdminQuizManagementController(),
    );
  }
}
