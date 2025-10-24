import 'package:get/get.dart';

import '../controllers/admin_create_subject_controller.dart';

// Binding for the Create Subject module. Register the controller lazily
// so it is created only when the create-subject route is navigated to.
class AdminCreateSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCreateSubjectController>(
      () => AdminCreateSubjectController(),
    );
  }
}
