import 'package:get/get.dart';

import 'quiz.controller.dart';

class QuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizController>(
      () => QuizController(),
    );
  }
}
