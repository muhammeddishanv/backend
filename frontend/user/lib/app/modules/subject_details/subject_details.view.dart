import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ed_tech/app/modules/subject_details/widgets/section_tile.dart';
import 'package:ed_tech/app/routes/app_pages.dart';

import 'subject_details.controller.dart';

/*
  This is the view for the course details module.
  It uses GetX for state management and responsive design.
  The view is designed to adapt to different screen sizes (phone, tablet, desktop).

  created by : Muhammed Shabeer OP
  date : 2025-08-07
  updated date : 2025-08-07
*/

/*
  Notes:
  - SubjectDetailsView shows course image, sections and a bottom action to view lessons.
  - Controller supplies `subject` and `sections`. This header was added 2025-10-23.
*/

class SubjectDetailsView extends GetResponsiveView<SubjectDetailsController> {
  SubjectDetailsView({super.key}) : super(alwaysUseBuilder: false);
  @override
  Widget phone() {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        height: 70,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.colorScheme.primary,
            foregroundColor: Get.theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            //* this will pass to view lesson
            Get.toNamed(
              Routes.LESSON,
              arguments: {'subject': controller.subject},
            );
          },
          child: Row(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Icon(Icons.play_arrow), const Text('View Lesson')],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          controller.subject.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.primary,
        foregroundColor: Get.theme.colorScheme.onPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Image.network(
              controller.subject.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          // Course Content (title)
          Text(
            "Subject Content",
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).paddingAll(16.0),
          // list details
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final section = controller.sections[index];
                return SectionTile(section: section);
              },
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemCount: controller.sections.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget tablet() => Icon(Icons.tablet, size: 75);
  @override
  Widget desktop() => Icon(Icons.desktop_mac, size: 75);
}
