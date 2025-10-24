import 'package:get/get.dart';

import '../controllers/admin_dashboard_controller.dart';

// Binding for the Admin Dashboard. Registers the AdminDashboardController
// which provides observable state used by the dashboard widgets.
class AdminDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
  }
}
