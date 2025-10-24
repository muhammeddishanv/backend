// lib/app/modules/quiz/quiz.view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../global_widgets/custom_search_bar.dart';
import 'quiz.controller.dart'; // assuming you have a QuizController
import 'views/question.view.dart';

/*
  This is the view for the quiz module.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  Now uses the reusable CustomSearchBar widget shared across the project.
  Colors are now handled using Get.theme.colorScheme (same as profile.view.dart)

  created by : Muhammed Shabeer OP
  date       : 2025-08-07
  updated    : 2025-08-27
*/

/*
  Notes:
  - QuizView contains several helper widgets (QuizCard, FilterChipWidget) and a
  simple static list for demo. Controller wiring expected via QuizController.
  - Header added 2025-10-23 for developer onboarding; no behavior changes.
*/

// -------------------- DATA MODEL --------------------
class QuizItem {
  final String title;
  final String image;
  final int questionCount;
  final int durationMinutes;

  const QuizItem({
    required this.title,
    required this.image,
    required this.questionCount,
    required this.durationMinutes,
  });
}

// -------------------- FILTER CHIP WIDGET --------------------
class FilterChipWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isSelected;

  const FilterChipWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.onSurfaceVariant.withAlpha(35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- QUIZ CARD WIDGET --------------------
class QuizCard extends StatelessWidget {
  final String quizTitle;
  final String quizImage;
  final int questionCount;
  final int durationMinutes;

  const QuizCard({
    super.key,
    required this.quizTitle,
    required this.quizImage,
    required this.questionCount,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Get.theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quizTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$questionCount Questions | $durationMinutes Minutes',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const QuestionView());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Start Quiz',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Image.network(
            quizImage,
            width: 85,
            height: 85,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 85,
                height: 85,
                color: colorScheme.surfaceVariant,
                child: Icon(
                  Icons.error_outline,
                  color: colorScheme.onSurfaceVariant,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// -------------------- MAIN QUIZ VIEW --------------------
class QuizView extends GetResponsiveView<QuizController> {
  QuizView({super.key}) : super(alwaysUseBuilder: false);

  final List<QuizItem> _staticQuizList = const [
    QuizItem(
      title: 'Kerala PSC LDC Mock Test',
      image: 'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
      questionCount: 100,
      durationMinutes: 90,
    ),
    QuizItem(
      title: 'Kerala PSC SI Mock Test',
      image: 'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
      questionCount: 120,
      durationMinutes: 120,
    ),
    QuizItem(
      title: 'Kerala PSC Degree Level Mock Test',
      image: 'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
      questionCount: 150,
      durationMinutes: 150,
    ),
  ];

  @override
  Widget? phone() {
    final colorScheme = Get.theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.background,
        centerTitle: true,
        title: Text(
          'Quiz',
          style: TextStyle(
            color: colorScheme.onBackground,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            CustomSearchBar(
              hintText: 'Search',
              backgroundColor: colorScheme.onSurfaceVariant.withAlpha(35),
              hintColor: Get.theme.colorScheme.onSurface,
              prefixIcon: Icon(
                Icons.search,
                color: Get.theme.colorScheme.onSurface,
              ),
              cursorAndTextColor: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterChipWidget(
                  icon: Icons.list,
                  label: 'Category',
                  onTap: () {},
                  isSelected: false,
                ),
                FilterChipWidget(
                  icon: Icons.list,
                  label: 'Difficulty',
                  onTap: () {},
                  isSelected: false,
                ),
                FilterChipWidget(
                  icon: Icons.list,
                  label: 'Subject',
                  onTap: () {},
                  isSelected: false,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sort', style: TextStyle(color: colorScheme.onBackground)),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Newest',
                    style: TextStyle(
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _staticQuizList.length,
                itemBuilder: (context, index) {
                  final quiz = _staticQuizList[index];
                  return QuizCard(
                    quizTitle: quiz.title,
                    quizImage: quiz.image,
                    questionCount: quiz.questionCount,
                    durationMinutes: quiz.durationMinutes,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget? tablet() => phone();

  @override
  Widget? desktop() => phone();
}
