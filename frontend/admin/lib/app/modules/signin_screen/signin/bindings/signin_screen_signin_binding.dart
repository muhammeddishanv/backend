import 'package:get/get.dart';

import '../controllers/signin_screen_signin_controller.dart';

class SigninScreenSigninBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SigninScreenSigninController>(
      () => SigninScreenSigninController(),
    );
  }
}
