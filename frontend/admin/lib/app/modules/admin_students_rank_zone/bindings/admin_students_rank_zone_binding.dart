// Binding for the Admin Students Rank Zone module.
// This file registers the module's controller with GetX dependency injection.
// It should remain a lightweight, non-UI wiring layer.
import 'package:get/get.dart';

import '../controllers/admin_students_rank_zone_controller.dart';

class AdminStudentsRankZoneBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily create the controller when this route/module is first used.
    Get.lazyPut<AdminStudentsRankZoneController>(
      () => AdminStudentsRankZoneController(),
    );
  }
}
