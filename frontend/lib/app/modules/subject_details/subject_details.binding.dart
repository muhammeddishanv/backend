import 'package:get/get.dart';

import 'subject_details.controller.dart';

class CourseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectDetailsController>(() => SubjectDetailsController());
  }
}
