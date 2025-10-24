// lib/app/modules/home/views/course.view.dart

import 'package:ed_tech/app/modules/home/controllers/subjects.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/subject_card_horizontal.dart';
import '../../../global_widgets/custom_search_bar.dart';

// Data model for a course
class Course {
  final String title;
  final String instructor;
  final String imageUrl;

  Course({
    required this.title,
    required this.instructor,
    required this.imageUrl,
  });
}

class SubjectsView extends GetResponsiveView<SubjectsController> {
  SubjectsView({super.key});

  @override
  Widget phone() {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text('Subjects'),
            centerTitle: true,
            backgroundColor: Get.theme.colorScheme.primary,
            foregroundColor: Get.theme.colorScheme.onPrimary,
            pinned: true,
            expandedHeight: Get.height * 0.20,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterTabs(),
                  SizedBox(height: 10),
                  _buildCustomSearchBar(),
                ],
              ).paddingAll(16),
            ),
          ),

          // Subjects list as a sliver
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return SubjectsCard(
                  course: Course(
                    title: 'Malayalam',
                    instructor: 'Mr. Hari Krishnan',
                    imageUrl:
                        'https://images.unsplash.com/photo-1551434678-e076c223a692?w=800',
                  ),
                  onTap: () {
                    // TODO: Add navigation or other logic here.
                  },
                );
              }, childCount: 10),
            ),
          ),

          // Bottom spacing
          SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filterTabs = ['All', 'My Subjects', 'Completed'];

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: filterTabs.map((tab) {
        return _buildFilterChip(
          tab,
          tab == 'All', // Default selection logic
        );
      }).toList(),
    );
  }

  Widget _buildFilterChip(String title, bool isSelected) {
    return ChoiceChip(
      label: Text(title),
      checkmarkColor: Get.theme.colorScheme.onPrimaryContainer,
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement state management to handle filter selection
      },
      selectedColor: Get.theme.colorScheme.onPrimary,
      labelStyle: TextStyle(
        color: Get.theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: isSelected
          ? Get.theme.colorScheme.primary
          : Get.theme.colorScheme.primaryContainer,
      shape: StadiumBorder(
        side: BorderSide(
          color: isSelected
              ? Get.theme.colorScheme.primary
              : Colors.transparent,
          width: 1,
        ),
      ),
    );
  }

  Widget _buildCustomSearchBar() {
    return CustomSearchBar(
      hintText: 'Search subject...',
      backgroundColor: Get.theme.colorScheme.surface,
      hintColor: Get.theme.colorScheme.onSurface,
      prefixIcon: Icon(Icons.search, color: Get.theme.colorScheme.onSurface),
      outlined: true,
      cursorAndTextColor: Get.theme.colorScheme.onSurface,
    );
  }
}
