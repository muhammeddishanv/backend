import 'package:get/get.dart';

// Controller for the Create Lesson view. Currently scaffolded with a simple
// observable `count` and lifecycle hooks. Extend this controller to handle
// form submission, API calls, validation, and state management for the
// Create Lesson flow.
class AdminCreateLessonController extends GetxController {
  // Example observable used by the generated template. Replace or extend
  // with real state (e.g., form fields, upload progress, validation state).
  final count = 0.obs;

  @override
  void onInit() {
    // Called immediately after the controller is allocated in memory.
    super.onInit();
  }

  @override
  void onReady() {
    // Called after the widget is rendered on screen. Good for starting
    // long-running tasks that require the UI to be present.
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose resources here when the controller is removed from memory.
    super.onClose();
  }

  // Example action to mutate state. Hook this up to UI events as needed.
  void increment() => count.value++;
}
