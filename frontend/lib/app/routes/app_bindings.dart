import 'package:get/get.dart';

import 'package:ed_tech/app/core/utils/helpers/toast_helper.dart';
import 'package:ed_tech/app/data/services/auth_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize AuthService asynchronously and register it properly
    Get.putAsync<AuthService>(() => AuthService().init(), permanent: true);
    Get.put(ToastHelper(), permanent: true);
  }
}
