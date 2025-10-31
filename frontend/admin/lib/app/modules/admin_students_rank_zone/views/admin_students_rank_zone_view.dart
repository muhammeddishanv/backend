// View for the Admin Students Rank Zone.
// This file defines responsive UI for the student ranking tables used in the admin dashboard.
// Pagination is fixed at the bottom of the screen (always visible).
// Table shows 8 rows per page — no scrolling inside the card.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../routes/app_pages.dart';

class AdminStudentsRankZoneView extends GetResponsiveView {
  AdminStudentsRankZoneView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget phone() => const SizedBox();
  @override
  Widget tablet() => const SizedBox();

  @override
  Widget desktop() {
    final List<String> categories = [
      'Biology',
      'Physics',
      'Chemistry',
      'IT',
      'English',
      'History',
    ];

    final RxString selectedCategory = 'Select Subject'.obs;

    final RxList<Map<String, dynamic>> overallRanks = <Map<String, dynamic>>[
      {"rank": 1, "student": "MARYAM", "score": 95, "progress": 95},
      {"rank": 2, "student": "RIFLI", "score": 92, "progress": 92},
      {"rank": 3, "student": "HARRY", "score": 90, "progress": 90},
      {"rank": 4, "student": "ABBAS", "score": 87, "progress": 87},
      {"rank": 5, "student": "ASGHAR", "score": 85, "progress": 85},
      {"rank": 6, "student": "FARNADI", "score": 82, "progress": 82},
      {"rank": 7, "student": "SEJAL", "score": 81, "progress": 81},
      {"rank": 8, "student": "AIDEN", "score": 79, "progress": 79},
      {"rank": 9, "student": "DARCY", "score": 77, "progress": 77},
      {"rank": 10, "student": "ELIZABETH", "score": 75, "progress": 75},
      {"rank": 11, "student": "JOHN", "score": 74, "progress": 74},
      {"rank": 12, "student": "RAY", "score": 73, "progress": 73},
    ].obs;

    final RxList<Map<String, dynamic>> subjectRanks = <Map<String, dynamic>>[
      {"rank": 1, "student": "JACK", "score": 88, "progress": 88},
      {"rank": 2, "student": "LISA", "score": 85, "progress": 85},
      {"rank": 3, "student": "TOM", "score": 83, "progress": 83},
      {"rank": 4, "student": "NINA", "score": 80, "progress": 80},
      {"rank": 5, "student": "SAM", "score": 78, "progress": 78},
      {"rank": 6, "student": "RITA", "score": 76, "progress": 76},
      {"rank": 7, "student": "VIKRAM", "score": 74, "progress": 74},
      {"rank": 8, "student": "JUNE", "score": 72, "progress": 72},
      {"rank": 9, "student": "OMAR", "score": 70, "progress": 70},
      {"rank": 10, "student": "PRIYA", "score": 68, "progress": 68},
      {"rank": 11, "student": "RAHUL", "score": 66, "progress": 66},
      {"rank": 12, "student": "SARA", "score": 65, "progress": 65},
    ].obs;

    // ---------- Pagination Table Builder ----------
    Widget rankTable(BuildContext context, List<Map<String, dynamic>> data,
        RxInt currentPage) {
      const int itemsPerPage = 8;
      int totalPages = (data.length / itemsPerPage).ceil();

      List<Map<String, dynamic>> getPaginatedData() {
        int start = (currentPage.value - 1) * itemsPerPage;
        int end = (start + itemsPerPage).clamp(0, data.length);
        return data.sublist(start, end);
      }

      final colorScheme = Theme.of(context).colorScheme;

      return Obx(() {
        List<Map<String, dynamic>> paginatedData = getPaginatedData();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2), width: 1),
              ),
              child: Column(
                children: [
                  // ---------- HEADER ----------
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border(
                        bottom: BorderSide(
                          color: colorScheme.outline.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60,
                          child: Text("RANK",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text("STUDENT",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurfaceVariant)),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text("SCORE",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurfaceVariant)),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text("PROGRESS",
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurfaceVariant)),
                        ),
                      ],
                    ),
                  ),

                  // ---------- BODY ----------
                  Column(
                    children: paginatedData.map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 20),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: colorScheme.outline.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 60,
                                child: Text("${s["rank"]}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500))),
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(s["student"],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500)),
                              ),
                            ),
                            SizedBox(
                                width: 80,
                                child: Text("${s["score"]}",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500))),
                            Expanded(
                              flex: 4,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: s["progress"] / 100,
                                        minHeight: 10,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                colorScheme.primary),
                                        backgroundColor:
                                            colorScheme.surfaceVariant,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  SizedBox(
                                    width: 40,
                                    child: Text("${s["progress"]}%",
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        );
      });
    }

    // ---------- MAIN DESKTOP UI ----------
    final RxInt currentOverallPage = 1.obs;
    final RxInt currentSubjectPage = 1.obs;

    return Scaffold(
      backgroundColor: Theme.of(Get.context!).colorScheme.surface,
      body: Stack(
        children: [
          Row(
            children: [
              AdminSidebar(
                selectedIndex: 11,
                onMenuSelected: (index) {
                  _navigateToPage(index);
                },
                onLogout: () => Get.offAllNamed(Routes.SIGNIN_SCREEN_SIGNIN),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---------- HEADING ----------
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 12),
                          child: Text(
                            "Student Rank Zone",
                            style: Theme.of(Get.context!)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),

                        // ---------- LEFT-ALIGNED TAB BAR ----------
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            isScrollable: true,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            labelColor: Theme.of(Get.context!)
                                .colorScheme
                                .primary,
                            unselectedLabelColor: Theme.of(Get.context!)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                            indicatorColor: Theme.of(Get.context!)
                                .colorScheme
                                .primary,
                            indicatorWeight: 3.0,
                            tabs: const [
                              Tab(text: "Overall"),
                              Tab(text: "Subject"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ---------- TAB VIEW CONTENT ----------
                        Expanded(
                          child: TabBarView(
                            children: [
                              rankTable(Get.context!, overallRanks,
                                  currentOverallPage),
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        SizedBox(
                                          width: 200,
                                          child:
                                              DropdownButtonFormField<String>(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Theme.of(Get.context!)
                                                  .colorScheme
                                                  .surfaceVariant,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            hint: Text(
                                              "Select Subject",
                                              style: TextStyle(
                                                color: Theme.of(Get.context!)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.6),
                                              ),
                                            ),
                                            items: categories
                                                .map((String value) =>
                                                    DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value),
                                                    ))
                                                .toList(),
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                selectedCategory.value =
                                                    newValue;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: rankTable(Get.context!,
                                        subjectRanks, currentSubjectPage),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ---------- FIXED PAGINATION BAR ----------
          Positioned(
            bottom: 0,
            left: 280,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Theme.of(Get.context!).colorScheme.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    int totalPages = (overallRanks.length / 8).ceil();
                    return Row(
                      children: [
                        for (int i = 1; i <= totalPages; i++)
                          GestureDetector(
                            onTap: () => currentOverallPage.value = i,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: currentOverallPage.value == i
                                    ? Theme.of(Get.context!)
                                        .colorScheme
                                        .primary
                                    : Theme.of(Get.context!)
                                        .colorScheme
                                        .surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '$i',
                                style: TextStyle(
                                  color: currentOverallPage.value == i
                                      ? Theme.of(Get.context!)
                                          .colorScheme
                                          .onPrimary
                                      : Theme.of(Get.context!)
                                          .colorScheme
                                          .onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.ADMIN_DASHBOARD);
        break;
      case 1:
        Get.toNamed(Routes.ADMIN_USER_MANAGEMENT);
        break;
      case 2:
        Get.toNamed(Routes.ADMIN_USER_DETAILS);
        break;
      case 3:
        Get.toNamed(Routes.ADMIN_SUBJECT_MANAGEMENT);
        break;
      case 6:
        Get.toNamed(Routes.ADMIN_CREATE_LESSON);
        break;
      case 7:
        Get.toNamed(Routes.ADMIN_EDIT_LESSON);
        break;
      case 8:
        Get.toNamed(Routes.ADMIN_CREATE_QUIZ);
        break;
      case 9:
        Get.toNamed(Routes.ADMIN_TRANSACTION_HISTORY);
        break;
      case 10:
        Get.toNamed(Routes.ADMIN_PERFORMANCE_ANALYSIS);
        break;
      case 11:
        Get.toNamed(Routes.ADMIN_STUDENTS_RANK_ZONE);
        break;
    }
  }
}