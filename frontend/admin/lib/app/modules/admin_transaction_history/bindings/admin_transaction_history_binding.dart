import 'package:get/get.dart';

import '../controllers/admin_transaction_history_controller.dart';

class AdminTransactionHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminTransactionHistoryController>(
      () => AdminTransactionHistoryController(),
    );
  }
}
