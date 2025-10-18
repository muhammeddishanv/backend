import 'package:get/get.dart';

import '../controllers/admin_user_management_controller.dart';

class AdminUserManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUserManagementController>(
      () => AdminUserManagementController(),
    );
  }
}