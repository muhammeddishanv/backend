import 'package:get/get.dart';

import '../controllers/admin_performance_analysis_controller.dart';

class AdminPerformanceAnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPerformanceAnalysisController>(
      () => AdminPerformanceAnalysisController(),
    );
  }
}