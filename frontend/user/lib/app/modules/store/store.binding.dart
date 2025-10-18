import 'package:get/get.dart';

import 'store.controller.dart';

class StoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StoreController>(
      () => StoreController(),
    );
  }
}
