import 'package:get/get.dart';

import '../controllers/admin_subject_management_controller.dart';

class AdminSubjectManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminSubjectManagementController>(
      () => AdminSubjectManagementController(),
    );
  }
}
