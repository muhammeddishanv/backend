import 'package:flutter/material.dart';

import 'package:get/get_utils/src/extensions/widget_extensions.dart';

import 'package:ed_tech/app/modules/subject_details/subject_details.controller.dart';

class SectionTile extends StatelessWidget {
  const SectionTile({required this.section});

  final CourseSection section;

  IconData _mapIcon(String name) {
    switch (name) {
      case 'book':
        return Icons.menu_book_outlined;
      case 'translate':
        return Icons.translate;
      case 'record_voice_over':
        return Icons.record_voice_over_outlined;
      case 'headset':
        return Icons.headset_outlined;
      case 'menu_book':
        return Icons.menu_book;
      default:
        return Icons.book_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: scheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(_mapIcon(section.icon), color: scheme.onPrimaryContainer),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                section.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                section.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
              ),
            ],
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 5);
  }
}
