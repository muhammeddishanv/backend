import 'package:get/get.dart';

import '../controllers/admin_students_rank_zone_controller.dart';

class AdminStudentsRankZoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminStudentsRankZoneController>(
      () => AdminStudentsRankZoneController(),
    );
  }
}
