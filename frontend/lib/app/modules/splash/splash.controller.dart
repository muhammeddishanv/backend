import 'package:get/get.dart';

import 'package:ed_tech/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // todo: check if user is logged in
    super.onInit();
  }

  @override
  void onReady() {
    // simulate a delay
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(Routes.AUTH); // Navigate to Auth page after delay
      // Get.offAllNamed(Routes.HOME); // Navigate to Home page after delay
    });

    super.onReady();
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
