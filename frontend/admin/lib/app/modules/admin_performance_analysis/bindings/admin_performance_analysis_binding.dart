import 'package:get/get.dart';

import '../controllers/admin_performance_analysis_controller.dart';

// Binding for Admin Performance Analysis screen.
// Registers the controller when the analysis route is activated.
class AdminPerformanceAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPerformanceAnalysisController>(
      () => AdminPerformanceAnalysisController(),
    );
  }
}
