import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'package:ed_tech/app/data/models/subject.model.dart';
import 'package:ed_tech/app/global_widgets/continue_learning_card.dart';
import 'package:ed_tech/app/global_widgets/custom_app_bar.dart';
import 'package:ed_tech/app/global_widgets/custom_search_bar.dart';
import 'package:ed_tech/app/global_widgets/subject_card.dart';
import 'package:ed_tech/app/modules/home/controllers/dashboard.controller.dart';
import 'package:ed_tech/app/routes/app_pages.dart';

/*
  DashboardView
  - Purpose: Main user dashboard. Shows enrolled courses, continue-learning area,
    and a sliver app bar with user quick actions.
  - Notes: Responsive via GetResponsiveView. Uses small helper widgets and cached
    images. This is a non-functional header to aid future readers.
  - Author: Muhammed Shabeer OP
  - Added: 2025-10-23 (annotation)
*/

class DashboardView extends GetResponsiveView<DashboardController> {
  DashboardView({super.key}) : super(alwaysUseBuilder: false);

  @override
  Widget? phone() {
    var subjectsArea = [
      Row(
        children: [
          Text(
            "Enrolled Courses",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text("See All")),
        ],
      ).paddingSymmetric(horizontal: 16, vertical: 8),
      SizedBox(
        height: 250,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            return SubjectCardVertical(
              title: 'Subject $index',
              instructor: 'Instructor $index',
              imageUrl:
                  'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
              onTap: () {
                // Navigate to course details or perform an action
                Get.toNamed(
                  Routes.COURSE_DETAILS,
                  arguments: {
                    'subject': SubjectModel(
                      subjectId: index,
                      title: 'Subject $index',
                      imageUrl:
                          'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
                    ),
                  },
                );
              },
              width: 200,
            );
          },
        ),
      ),
    ];
    var continueLearningArea = [
      Row(
        children: [
          Text(
            "Continue Learning",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          TextButton(onPressed: () {}, child: const Text("See All")),
        ],
      ).paddingOnly(left: 16, right: 16, bottom: 8),
      // continue learning area
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ContinueLearningCard(
          lessonLabel: 'Lesson 3',
          title: 'Mathematics Fundamental Algebra',
          subtitle: 'Introduction to Algebra',
          imageUrl:
              'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
          progress: 0.90,
          onContinue: () {},
        ),
      ),
    ];

    return GestureDetector(
      onTap: () {
        FocusScope.of(Get.context!).unfocus(); // Dismiss keyboard on tap
      },
      child: Scaffold(
        primary: true,
        // Converting to a sliver-based layout using CustomScrollView
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...subjectsArea,
                  ...continueLearningArea,
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
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

  SliverAppBar _buildSliverAppBar() {
    Chip userDChip(IconData icon, String value) => Chip(
      labelPadding: EdgeInsets.zero,
      avatar: Icon(icon, color: Get.theme.colorScheme.primary, size: 16),
      label: Text(
        value,
        style: TextStyle(
          color: Get.theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(color: Get.theme.colorScheme.onPrimary),
      ),
    );

    final expandedHeight =
        (Get.height * 0.10) + 48 + 20 + 50 + 60; // matches previous layout

    return SliverAppBar(
      pinned: true,
      expandedHeight: expandedHeight,
      backgroundColor: Get.theme.colorScheme.primary,
      elevation: 0,
      centerTitle: false,
      collapsedHeight: kToolbarHeight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          return FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: CustomTopBar(
              // disable its internal safe area so we can manage it here
              safeArea: false,
              child: SafeArea(
                bottom: false,
                child: Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.02,
                    bottom: Get.height * 0.02,
                    left: Get.width * 0.05,
                    right: Get.width * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Get.theme.colorScheme.onPrimary,
                            ),
                            onPressed: () {},
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                            onPressed: () {},
                            icon: Badge.count(
                              smallSize: 10,
                              isLabelVisible: true,
                              offset: const Offset(5, -5),
                              count: 3,
                              child: Icon(
                                Icons.notifications,
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                            label: Text(
                              'Notifications',
                              style: TextStyle(
                                color: Get.theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: Get.width * 0.02),
                          CircleAvatar(
                            radius: 30,
                            // changed to cached network image
                            backgroundImage: CachedNetworkImageProvider(
                              'https://avatar.iran.liara.run/public/40',
                            ),
                            backgroundColor: Get.theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: Get.width * 0.6,
                                child: Text(
                                  'Hello, Muhammed Shabeer OP',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Get.theme.colorScheme.onPrimary,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              IntrinsicWidth(
                                stepWidth: 100,
                                child: Row(
                                  children: [
                                    userDChip(Icons.star_outline, '100'),
                                    const SizedBox(width: 10),
                                    userDChip(Icons.monetization_on, '50'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const CustomSearchBar(
                        hintText: "Search course...",
                        readOnly: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
