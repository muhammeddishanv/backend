// lib/app/global_widgets/subjectscard.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/home/views/subjects.view.dart';

class SubjectsCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const SubjectsCard({super.key, required this.course, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final colorScheme = theme.colorScheme;
    final screenWidth = Get.width;

    // Adaptive sizes
    final imageSize = screenWidth * 0.18; // 18% of screen width
    final buttonWidth = screenWidth * 0.25; // 25% of screen width

    return Card(
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          children: [
            // Responsive image with a fixed size
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                course.imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
    
            // Text section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    course.instructor,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
    
            // Responsive button
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.025,
                  ),
                ),
                child: const Text('View'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
