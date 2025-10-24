import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'final_answer_review.view.dart';

/*
  This is the view for the quiz answer review module.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Muhammed Dishan.v
  date : 2025-08-26
  updated date : 2025-08-26
*/
class ReviewAnswersView extends GetResponsiveView {
  ReviewAnswersView({super.key}) : super(alwaysUseBuilder: false);

  final List<_AnswerPageData> _pages = [
    _AnswerPageData(progress: 0.22, questionNumber: 1),
    _AnswerPageData(progress: 0.63, questionNumber: 2),
    _AnswerPageData(progress: 1.0, questionNumber: 3),
  ];

  final RxInt pageIndex = 0.obs;

  @override
  Widget? phone() {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Answers'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Obx(() {
            // Ensure pageIndex stays within bounds
            if (pageIndex.value >= _pages.length) {
              pageIndex.value = _pages.length - 1;
            }
            if (pageIndex.value < 0) {
              pageIndex.value = 0;
            }

            final page = _pages[pageIndex.value];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Question ${page.questionNumber} of 3',
                  style: TextStyle(
                    fontSize: 15,
                    color: Get.theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                _ProgressBar(progress: page.progress),
                const SizedBox(height: 32),
                // Main content separated into widget
                const _ReviewAnswerContent(),
                const Spacer(),
                _NavigationButtons(
                  pageIndex: pageIndex,
                  totalPages: _pages.length,
                ),
                const SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget? tablet() => phone();

  @override
  Widget? desktop() => phone();
}

class _AnswerPageData {
  final double progress;
  final int questionNumber;
  const _AnswerPageData({required this.progress, required this.questionNumber});
}

/// Progress bar widget (theme-based)
class _ProgressBar extends StatelessWidget {
  final double progress;
  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Theme.of(context).colorScheme.surface,
        color: Theme.of(context).colorScheme.primary,
        minHeight: 5,
      ),
    );
  }
}

/// Review Answer Content - separated widget as per instructions
class _ReviewAnswerContent extends StatelessWidget {
  const _ReviewAnswerContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is the primary function of the legislative branch in a parliamentary system?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 28),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
            ),
            children: [
              const TextSpan(
                text: 'Your answer: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'To interpret laws and ensure their fair application.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 15,
            ),
            children: [
              const TextSpan(
                text: 'Correct answer: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'To make laws and oversee the executive branch.',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Navigation Buttons - separated widget as per instructions
class _NavigationButtons extends StatelessWidget {
  final RxInt pageIndex;
  final int totalPages;

  const _NavigationButtons({required this.pageIndex, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (pageIndex.value > 0)
          _ThemeButton(
            text: "Previous",
            onPressed: () {
              if (pageIndex.value > 0) {
                pageIndex.value--;
              }
            },
            isOutlined: true,
          )
        else
          const SizedBox.shrink(),
        if (pageIndex.value < totalPages - 1)
          _ThemeButton(
            text: "Next",
            onPressed: () {
              if (pageIndex.value < totalPages - 1) {
                pageIndex.value++;
              }
            },
          ),
        if (pageIndex.value == totalPages - 1)
          _ThemeButton(
            text: "View Full Answer",
            onPressed: () {
              Get.to(() => FinalAnswerReviewView());
            },
          ),
      ],
    );
  }
}

/// Theme-based button widget - follows project patterns
class _ThemeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;

  const _ThemeButton({
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: theme.colorScheme.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          minimumSize: const Size(100, 40),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(100, 40),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
