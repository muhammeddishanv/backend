import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'answer_review.view.dart';

class QuizResultView extends GetResponsiveView {
  QuizResultView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget? phone() {
    return Builder(
      builder: (context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      ..._buildResultHeader(),
                      const SizedBox(height: 30),
                      ..._buildResultSummary(),
                    ],
                  ),
                ),
              ),
              ..._buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget? tablet() {
    return phone(); // simple reuse for now
  }

  @override
  Widget? desktop() {
    return phone(); // simple reuse for now
  }

  AppBar _buildAppBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      title: Text(
        "Quiz Result",
        style: TextStyle(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.close, color: colorScheme.onSurface),
        onPressed: () => Get.back(),
      ),
      backgroundColor: colorScheme.surface,
      elevation: 0,
    );
  }

  List<Widget> _buildResultHeader() {
    return [
      // Title & Success Message
      Builder(
        builder: (context) => Text(
          "Congratulations! You passed the exam",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      const SizedBox(height: 24),
      // Circular Image/Icon
      Builder(
        builder: (context) => CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Image.asset(
            'assets/plant_icon.png',
            width: 60,
            height: 60,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.eco,
              size: 50,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      const SizedBox(height: 20),
      // Exam Title
      Builder(
        builder: (context) => Text(
          "Kerala PSC Mock Exam",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      // Score
      Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            "Score: 85/100",
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.outline,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildResultSummary() {
    return [
      // Result Summary (Correct, Wrong, Skipped)
      Builder(
        builder: (context) => Row(
          children: [
            Expanded(
              child: _resultBox(
                "Correct",
                "3",
                Color.fromARGB(255, 6, 140, 10),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _resultBox(
                "Wrong",
                "5",
                Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),
      // Full width Skipped box
      Builder(
        builder: (context) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Skipped",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "1",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildActionButtons() {
    return [
      Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _retryQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Retry Quiz",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _reviewAnswers();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Review Answers",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  // Action methods
  void _retryQuiz() {
    // Handle retry quiz logic
    // For example: Navigate back to quiz or reset quiz state
    Get.back(); // or navigate to quiz page
  }

  void _reviewAnswers() {
    // Navigate to the answer review page
    Get.to(() => ReviewAnswersView());
  }

  // Custom widget for result box (for Correct and Wrong only)
  Widget _resultBox(String title, String value, Color borderColor) {
    // Add [fillColor] param for background if needed
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
