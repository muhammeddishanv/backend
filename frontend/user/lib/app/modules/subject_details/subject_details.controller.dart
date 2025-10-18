import 'package:get/get.dart';

import 'package:ed_tech/app/data/models/subject.model.dart';

class SubjectDetailsController extends GetxController {
  late SubjectModel subject;

  // Represents sections/chapters inside a course (e.g., Grammar, Vocabulary...)
  final sections = <CourseSection>[
    CourseSection(
      title: 'Grammar',
      description:
          'Learn the basics of English grammar, including sentence structure, parts of speech, and common rules.',
      icon: 'book',
    ),
    CourseSection(
      title: 'Vocabulary',
      description:
          'Expand your vocabulary with common words and phrases used in everyday situations.',
      icon: 'translate',
    ),
    CourseSection(
      title: 'Speaking',
      description:
          'Practice speaking English with interactive exercises and real-life scenarios.',
      icon: 'record_voice_over',
    ),
    CourseSection(
      title: 'Listening',
      description:
          'Improve your listening skills with audio recordings and comprehension quizzes.',
      icon: 'headset',
    ),
    CourseSection(
      title: 'Reading',
      description:
          'Enhance your reading comprehension with engaging texts and reading exercises.',
      icon: 'menu_book',
    ),
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    subject = Get.arguments['subject'] as SubjectModel;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

class CourseSection {
  final String title;
  final String description;
  // Using a string for icon name keeps it simple; we map it in the view.
  final String icon;

  const CourseSection({
    required this.title,
    required this.description,
    required this.icon,
  });
}
