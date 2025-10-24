import 'package:get/get.dart';

import '../controllers/admin_user_details_controller.dart';

class AdminUserDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUserDetailsController>(
      () => AdminUserDetailsController(),
    );
  }
}