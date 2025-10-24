// Binding for Admin Edit Subject module.
// Registers the subject editing controller when the route is opened.
import 'package:get/get.dart';

import '../controllers/admin_edit_subject_controller.dart';

class AdminEditSubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminEditSubjectController>(() => AdminEditSubjectController());
  }
}
