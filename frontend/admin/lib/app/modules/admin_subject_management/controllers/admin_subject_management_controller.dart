// Controller for Admin Subject Management.

// Responsibilities: manage subject list state, editing flags and API interactions.

// Put network/fetching logic and transformation here; keep the view focused on UI.

import 'package:get/get.dart';

class AdminSubjectManagementController extends GetxController {
  // Example reactive field — replace with real Subject model list.
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controller state (e.g., load subjects)
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose resources if needed
    super.onClose();
  }

  // Example helper method to mutate reactive state.
  void increment() => count.value++;
}
