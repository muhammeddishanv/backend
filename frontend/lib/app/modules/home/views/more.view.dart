import 'package:ed_tech/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreView {
  static void showMoreOptions() {
    final List<Map<String, dynamic>> moreOptions = [
      {"icon": Icons.store_outlined, "title": "Store"},
      {"icon": Icons.history, "title": "History"},
      {"icon": Icons.bar_chart_outlined, "title": "Performance"},
      {"icon": Icons.quiz_outlined, "title": "Quiz"},
    ];

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: moreOptions.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: Get.theme.colorScheme.onSurface.withAlpha(30),
              ),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(
                    moreOptions[index]["icon"],
                    color: Get.theme.colorScheme.onSurface,
                  ),
                  title: Text(
                    moreOptions[index]["title"],
                    style: TextStyle(
                      color: Get.theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    switch (moreOptions[index]["title"]) {
                      case "Store":
                        Get.toNamed(Routes.STORE);
                        break;
                      case "History":
                        Get.toNamed(Routes.HISTORY);
                        break;
                      case "Performance":
                        Get.toNamed(Routes.PERFORMANCE);
                        break;
                      case "Quiz":
                        Get.toNamed(Routes.QUIZ);
                        break;
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 115),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
