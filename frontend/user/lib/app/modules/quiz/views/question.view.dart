import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'quiz_result.view.dart';
import 'dart:async';

/*
  This is the view for the Question module.
  ✅ Updated to allow MULTIPLE answers selection with CIRCULAR bullets on the LEFT (like radio buttons).
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Deena Fathima
  updated : 2025-08-25
*/

class QuestionView extends GetView {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    // Local state for selected options (multiple selections allowed)
    final RxList<String> selectedOptions = <String>[].obs;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: const Text(
          "Kerala PSC",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () => Get.back(),
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Question number and timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Question 1/3",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),

                /// 👇 Reusable countdown widget
                CountdownTimer(
                  seconds: 59,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            /// Question text
            const Text(
              "Which of the following are rivers in Kerala?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),

            /// Options
            Expanded(
              child: ListView(
                children: [
                  optionTile("Periyar", selectedOptions, theme),
                  optionTile("Bharathapuzha", selectedOptions, theme),
                  optionTile("Pamba", selectedOptions, theme),
                  optionTile("Chaliyar", selectedOptions, theme),
                ],
              ),
            ),

            /// Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2F2F5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Previous",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => QuizResultView());
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable option widget with CIRCULAR bullet
  Widget optionTile(
    String text,
    RxList<String> selectedOptions,
    ThemeData theme,
  ) {
    return Obx(() {
      final bool isSelected = selectedOptions.contains(text);

      return InkWell(
        onTap: () {
          if (isSelected) {
            selectedOptions.remove(text);
          } else {
            selectedOptions.add(text);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF2F2F5) : Colors.white,
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.grey.shade400,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              /// 👇 Custom circular bullet
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey.shade500,
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              /// Text label
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// 👇 Reusable Countdown Timer widget
class CountdownTimer extends StatefulWidget {
  final int seconds;
  final TextStyle? textStyle;

  const CountdownTimer({super.key, required this.seconds, this.textStyle});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int remainingSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.seconds;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, "0");
    final seconds = (remainingSeconds % 60).toString().padLeft(2, "0");

    return Text("$minutes:$seconds", style: widget.textStyle);
  }
}
