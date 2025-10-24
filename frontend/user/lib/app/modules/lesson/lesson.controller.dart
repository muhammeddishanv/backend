import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:ed_tech/app/core/utils/helpers/toast_helper.dart';
import 'package:ed_tech/app/data/models/subject.model.dart';
import 'package:ed_tech/app/routes/app_pages.dart';

/// Types of lesson content items.
enum LessonItemType { video, quiz, material, special }

/// Status of a lesson item for the learner.
enum LessonStatus { locked, available, completed }

/// Individual curriculum item (video lesson, quiz, downloadable material, etc.)
class LessonItem {
  LessonItem({
    required this.id,
    required this.title,
    required this.type,
    this.status = LessonStatus.locked,
    this.durationMinutes,
  });

  final String id;
  final String title;
  final LessonItemType type;
  final int? durationMinutes; // For videos / estimated time
  LessonStatus status; // mutable for demo progression
}

/// A chapter groups multiple lesson items.
class ChapterModel {
  ChapterModel({
    required this.id,
    required this.title,
    required List<LessonItem> items,
    bool initiallyExpanded = false,
  }) : items = items,
       expanded = initiallyExpanded.obs;

  final String id;
  final String title;
  final List<LessonItem> items;
  final RxBool expanded;
}

class LessonController extends GetxController {
  late SubjectModel subject;

  /// All chapters for the subject.
  final chapters = <ChapterModel>[].obs;

  /// Track current playing / viewing item (if any)
  final currentItem = Rxn<LessonItem>();

  /// Computed overall progress (0-1). Uses number of completed items vs total.
  double get progress {
    final total = chapters.fold<int>(0, (sum, c) => sum + c.items.length);
    if (total == 0) return 0;
    final completed = chapters
        .expand((c) => c.items)
        .where((i) => i.status == LessonStatus.completed)
        .length;
    return completed / total;
  }

  /// Formatted progress percent (e.g., 32%)
  String get progressLabel => '${(progress * 100).toStringAsFixed(0)}%';

  @override
  void onInit() {
    subject = Get.arguments['subject'] as SubjectModel;
    _seedDemoData();
    super.onInit();
  }

  void _seedDemoData() {
    // Demo curriculum mirroring screenshot structure.
    chapters.addAll([
      ChapterModel(
        id: 'c1',
        title: 'Chapter 1: Motion and Forces',
        initiallyExpanded: true,
        items: [
          LessonItem(
            id: 'l1',
            title: 'Lesson 1.1: What is Physics?',
            type: LessonItemType.video,
            status: LessonStatus.completed,
            durationMinutes: 5,
          ),
          LessonItem(
            id: 'q1',
            title: 'Lesson 1.1 Quiz',
            type: LessonItemType.quiz,
            status: LessonStatus.completed,
          ),
          LessonItem(
            id: 'l2',
            title: 'Lesson 1.2: How Things Move',
            type: LessonItemType.video,
            status: LessonStatus.completed,
            durationMinutes: 8,
          ),
          LessonItem(
            id: 'q2',
            title: 'Lesson 1.2 Quiz',
            type: LessonItemType.quiz,
            status: LessonStatus.completed,
          ),
          LessonItem(
            id: 'l3',
            title: 'Lesson 1.3: Speed vs Velocity',
            type: LessonItemType.video,
            status: LessonStatus.completed,
            durationMinutes: 6,
          ),
          LessonItem(
            id: 'q3',
            title: 'Lesson 1.3 Quiz',
            type: LessonItemType.quiz,
            status: LessonStatus.completed,
          ),
          LessonItem(
            id: 'sv1',
            title: 'Special Video',
            type: LessonItemType.special,
            status: LessonStatus.completed,
            durationMinutes: 4,
          ),
          LessonItem(
            id: 'm1',
            title: 'Material: All About Motion',
            type: LessonItemType.material,
            status: LessonStatus.completed,
          ),
        ],
      ),
      ChapterModel(
        id: 'c2',
        title: 'Chapter 2: Heat and Temperature',
        items: [
          LessonItem(
            id: 'l21',
            title: 'Lesson 2.1: What is Heat?',
            type: LessonItemType.video,
            status: LessonStatus.available,
            durationMinutes: 7,
          ),
          LessonItem(
            id: 'q21',
            title: 'Lesson 2.1 Quiz',
            type: LessonItemType.quiz,
            status: LessonStatus.locked,
          ),
          LessonItem(
            id: 'l22',
            title: 'Lesson 2.2: How Heat Moves Around',
            type: LessonItemType.video,
            status: LessonStatus.locked,
            durationMinutes: 9,
          ),
          LessonItem(
            id: 'q22',
            title: 'Lesson 2.2 Quiz',
            type: LessonItemType.quiz,
            status: LessonStatus.locked,
          ),
          LessonItem(
            id: 'l23',
            title: 'Lesson 2.3: States of Matter & Heat',
            type: LessonItemType.video,
            status: LessonStatus.locked,
            durationMinutes: 10,
          ),
          LessonItem(
            id: 'q23',
            title: 'Lesson 2.3 Quiz',
            type: LessonItemType.quiz,
            status: LessonStatus.locked,
          ),
          LessonItem(
            id: 'sv2',
            title: 'Special Video',
            type: LessonItemType.special,
            status: LessonStatus.locked,
          ),
          LessonItem(
            id: 'm2',
            title: 'Material: Heat and Temperature',
            type: LessonItemType.material,
            status: LessonStatus.locked,
          ),
        ],
      ),
      ChapterModel(
        id: 'c3',
        title: 'Chapter 3: Electricity and Magnetism',
        items: [
          LessonItem(
            id: 'l31',
            title: 'Lesson 3.1: Intro to Electricity',
            type: LessonItemType.video,
            status: LessonStatus.locked,
            durationMinutes: 6,
          ),
        ],
      ),
      ChapterModel(
        id: 'c4',
        title: 'Chapter 4: Light and Sound',
        items: [
          LessonItem(
            id: 'l41',
            title: 'Lesson 4.1: What is Light?',
            type: LessonItemType.video,
            status: LessonStatus.locked,
            durationMinutes: 5,
          ),
        ],
      ),
    ]);
  }

  /// Toggle expansion state of a chapter.
  void toggleChapter(ChapterModel chapter) => chapter.expanded.toggle();

  /// Attempt to open an item. Returns false if locked.
  bool openItem(LessonItem item) {
    if (item.status == LessonStatus.locked) {
      Get.find<ToastHelper>().showError('Complete previous lessons first');
      return false;
    }
    currentItem.value = item;
    // Example progression: mark available item as completed after opening.
    if (item.status == LessonStatus.available) {
      item.status = LessonStatus.completed;
      _unlockNext(item);
      chapters.refresh(); // trigger UI
    }
    // Navigate to appropriate view based on item type
    if (item.type == LessonItemType.quiz) {
      Get.toNamed(Routes.QUIZ);
    }
    return true;
  }

  void _unlockNext(LessonItem justCompleted) {
    // Find next locked item globally and unlock it (simple linear progression)
    final flat = chapters.expand((c) => c.items).toList();
    for (int i = 0; i < flat.length; i++) {
      if (flat[i].id == justCompleted.id && i + 1 < flat.length) {
        final next = flat[i + 1];
        if (next.status == LessonStatus.locked) {
          next.status = LessonStatus.available;
        }
        break;
      }
    }
  }

  IconData iconForType(LessonItemType type) {
    switch (type) {
      case LessonItemType.video:
        return Icons.play_circle_outline;
      case LessonItemType.quiz:
        return Icons.quiz_outlined;
      case LessonItemType.material:
        return Icons.description_outlined;
      case LessonItemType.special:
        return Icons.star_outline;
    }
  }
}
