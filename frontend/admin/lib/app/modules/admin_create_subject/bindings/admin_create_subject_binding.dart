import 'package:get/get.dart';

import '../controllers/admin_create_subject_controller.dart';

class AdminCreateSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCreateSubjectController>(
      () => AdminCreateSubjectController(),
    );
  }
}
