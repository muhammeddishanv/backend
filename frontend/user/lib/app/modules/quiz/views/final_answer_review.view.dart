import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../quiz.view.dart';

class FinalAnswerReviewView extends GetResponsiveView {
  FinalAnswerReviewView({super.key}) : super(alwaysUseBuilder: false);

  // Example data: 0 = wrong, 1 = correct, null = not attended
  final List<int?> answers = List.generate(6, (index) {
    if (index % 5 == 0) return null; // not attended
    if (index % 2 == 0) return 1; // correct
    return 0; // wrong
  });

  @override
  Widget? phone() {
    final cs = Get.theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "ANSWERS",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FinalAnswerReviewContent(answers: answers),
    );
  }

  @override
  Widget? tablet() => phone();

  @override
  Widget? desktop() => phone();
}

/// ✅ Separated body content widget
class FinalAnswerReviewContent extends StatelessWidget {
  final List<int?> answers;

  const FinalAnswerReviewContent({super.key, required this.answers});

  Color getColor(int? status, BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    if (status == null) return theme.outline; // not attended
    if (status == 1) return Colors.green; // correct
    return theme.error; // wrong
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 10),
        _legendRow(context),

        // ⚪ Curved Overlay Container
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadow.withAlpha(25), // instead of withOpacity
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // ✅ Scrollable answers
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 20,
                    ),
                    itemCount: (answers.length / 7).ceil(),
                    itemBuilder: (context, rowIndex) {
                      final start = rowIndex * 7;
                      final end = (start + 7).clamp(0, answers.length);
                      final rowAnswers = answers.sublist(start, end);

                      return _buildAnswerRow(
                        context,
                        rowAnswers,
                        start,
                        answers.length,
                      );
                    },
                  ),
                ),

                // ✅ Submit button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: 200,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Get.offAll(() => QuizView());
                      },
                      child: Text(
                        "Finish",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// ✅ Each row of questions has one continuous line below it
  Widget _buildAnswerRow(
    BuildContext context,
    List<int?> rowAnswers,
    int start,
    int totalCount,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(rowAnswers.length, (i) {
            final status = rowAnswers[i];
            final qNumber = start + i + 1;

            return CircleAvatar(
              radius: 20,
              backgroundColor: getColor(status, context),
              child: Text(
                "$qNumber",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Divider(color: Theme.of(context).colorScheme.outline, thickness: 1),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _legendRow(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(theme.outline, "Not attended", context),
        const SizedBox(width: 15),
        _legendItem(Colors.green, "Correct Answer", context),
        const SizedBox(width: 15),
        _legendItem(theme.error, "Wrong Answer", context),
      ],
    );
  }

  Widget _legendItem(Color color, String text, BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(fontSize: 12, color: theme.onBackground)),
        ],
      ),
    );
  }
}
