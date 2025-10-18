import 'package:get/get.dart';

import 'performance.controller.dart';

class PerformanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerformanceController>(
      () => PerformanceController(),
    );
  }
}
