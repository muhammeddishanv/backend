import 'package:get/get.dart';

import '../controllers/admin_create_quiz_controller.dart';

// Binding for the Create Quiz module. Register controllers and other
// dependencies that should be instantiated when the create-quiz route
// becomes active. Using lazyPut defers instantiation until the route is
// actually navigated to which keeps startup time small.
class AdminCreateQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminCreateQuizController>(() => AdminCreateQuizController());
  }
}
