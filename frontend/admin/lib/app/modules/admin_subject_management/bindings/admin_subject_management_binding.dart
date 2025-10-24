// Binding for Admin Subject Management module.
// Registers controller and other DI for this module.
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
