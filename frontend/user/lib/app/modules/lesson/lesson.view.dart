import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import 'lesson.controller.dart';

class LessonView extends GetView<LessonController> {
  const LessonView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.subject.title),
        backgroundColor: theme.colorScheme.surface,
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressSection().paddingAll(16),
            _buildPlayerPreview(),
            _buildCourseDetails().paddingAll(16),
            _buildInstructor().paddingOnly(left: 16, right: 16, bottom: 16),
            // Chapters list (non-scrollable inside parent scroll)
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.chapters.length,
              itemBuilder: (context, index) {
                final chapter = controller.chapters[index];
                return _ChapterWidget(chapter: chapter, controller: controller);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    final theme = Get.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Course Progress', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: controller.progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.primaryContainer,
            valueColor: AlwaysStoppedAnimation(theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerPreview() {
    //todo : implement video player
    //! ---> Video Player <--- HERE
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Center(
          child: Text('Video Player', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildCourseDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          "Lesson 1.1 : What is physics?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          "Learn the basics of Physics, including motion, force, energy, and simple machines, through fun and hands-on experiments.",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildInstructor() {
    // instructor photo and name
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: CachedNetworkImageProvider(
            "https://avatar.iran.liara.run/public/12",
          ),
          // backgroundImage: CachedNetworkImageProvider("https://avatar.iran.liara.run/public/12"), //! IGNORE
        ),
        SizedBox(width: 10),
        Text(
          "John Doe",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ChapterWidget extends StatelessWidget {
  const _ChapterWidget({required this.chapter, required this.controller});
  final ChapterModel chapter;
  final LessonController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor.withAlpha(50)),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => controller.toggleChapter(chapter),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        chapter.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(
                      chapter.expanded.value
                          ? Icons.expand_less
                          : Icons.expand_more,
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
            if (chapter.expanded.value)
              Column(
                children: [
                  const Divider(height: 1),
                  ..._buildItemsWithDivider(chapter),
                ],
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItemsWithDivider(ChapterModel chapter) {
    final widgets = <Widget>[];
    bool dividerInserted = false;
    for (var i = 0; i < chapter.items.length; i++) {
      final item = chapter.items[i];
      final isSpecialOrMaterial =
          item.type == LessonItemType.special ||
          item.type == LessonItemType.material;
      if (isSpecialOrMaterial && !dividerInserted) {
        // Insert a labeled divider before the first special/material item group.
        widgets.add(const _LabeledDivider(label: 'Special Video & Materials'));
        dividerInserted = true;
      }
      widgets.add(_LessonItemTile(item: item, controller: controller));
    }
    return widgets;
  }
}

class _LabeledDivider extends StatelessWidget {
  const _LabeledDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 2, left: 12, right: 12),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: theme.dividerColor.withAlpha(50),
              endIndent: 8,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          Expanded(
            child: Divider(color: theme.dividerColor.withAlpha(50), indent: 8),
          ),
        ],
      ),
    );
  }
}

class _LessonItemTile extends StatelessWidget {
  const _LessonItemTile({required this.item, required this.controller});
  final LessonItem item;
  final LessonController controller;

  Color _statusColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (item.status) {
      case LessonStatus.completed:
        return Colors.green;
      case LessonStatus.available:
        return cs.primary;
      case LessonStatus.locked:
        return cs.error;
    }
  }

  Widget _statusIcon() {
    switch (item.status) {
      case LessonStatus.completed:
        return const Icon(Icons.check, size: 16, color: Colors.green);
      case LessonStatus.available:
        return const Icon(Icons.play_arrow, size: 16, color: Colors.blue);
      case LessonStatus.locked:
        return const Icon(
          Icons.lock_outline,
          size: 16,
          color: Colors.redAccent,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final icon = controller.iconForType(item.type);
    return InkWell(
      onTap: () => controller.openItem(item),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      decoration: item.status == LessonStatus.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.durationMinutes != null)
                    Text(
                      '${item.durationMinutes} min',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: theme.textTheme.bodySmall?.color?.withAlpha(178),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _statusIcon(),
            const SizedBox(width: 6),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _statusColor(context),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
