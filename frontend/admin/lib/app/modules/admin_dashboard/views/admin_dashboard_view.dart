import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/nav_bar.dart';
import '../../../routes/app_pages.dart';

// Admin Dashboard view. Composed of a sidebar (AdminSidebar) and a set of
// dashboard cards (quick actions, new joiners, peak time chart). Widgets
// are intentionally simple and rely on the controller for reactive state.
class AdminDashboardView extends GetResponsiveView {
  AdminDashboardView({super.key});

  /// ---------------- PHONE VIEW ----------------
  @override
  Widget phone() => const SizedBox(); // not needed

  /// ---------------- TABLET VIEW ----------------
  @override
  Widget tablet() => const SizedBox(); // not needed

  /// ---------------- DESKTOP VIEW ----------------
  @override
  Widget desktop() {
    return Scaffold(
      backgroundColor: Theme.of(Get.context!).colorScheme.background,
      body: Row(
        children: [
          /// ---------- SIDEBAR ----------
          AdminSidebar(
            selectedIndex: 0,
            onMenuSelected: (index) {
              _navigateToPage(index);
            },
            onLogout: () {
              // Handle logout
            },
          ),

          /// ---------- MAIN CONTENT ----------
          Expanded(
            child: Scaffold(
              backgroundColor: Theme.of(Get.context!).colorScheme.background,
              body: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Page Title
                    Text(
                      "Admin Dashboard",
                      style: Theme.of(Get.context!).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              Get.context!,
                            ).colorScheme.onBackground,
                          ),
                    ),

                    const SizedBox(height: 30),

                    /// Quick Actions
                    _buildQuickActions(Get.context!),

                    const SizedBox(height: 30),

                    /// Main Content Row
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildNewJoinersCard(Get.context!)),
                          const SizedBox(width: 30),
                          Expanded(child: _buildPeakTimeCard(Get.context!)),
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
    );
  }

  // ---------------- REUSABLE WIDGETS ----------------

  static Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickAction(
          context,
          Icons.menu_book,
          "Create Subject",
          Theme.of(context).colorScheme.primary,
          () => Get.toNamed(Routes.ADMIN_SUBJECT_MANAGEMENT),
        ),
        _quickAction(
          context,
          Icons.lock_open,
          "Unlock Subject",
          Theme.of(context).colorScheme.secondary,
          () => Get.toNamed(Routes.ADMIN_USER_DETAILS),
        ),
        _quickAction(
          context,
          Icons.person_add,
          "Add User",
          Theme.of(context).colorScheme.tertiary,
          () => Get.toNamed(Routes.ADMIN_USER_MANAGEMENT),
        ),
        _quickAction(
          context,
          Icons.quiz,
          "Create Quiz",
          Theme.of(context).colorScheme.primary,
          () => Get.toNamed(Routes.QUIZ_MANAGEMENT),
        ),
      ],
    );
  }

  static Widget _quickAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildNewJoinersCard(BuildContext context) {
    final users = [
      {"name": "Ethan Carter", "status": true},
      {"name": "Sophia Bent", "status": true},
      {"name": "Liam Harper", "status": false},
      {"name": "Olivia Reed", "status": true},
      {"name": "Noah Foster", "status": true},
      {"name": "Ava Morgan", "status": false},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Joiners",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant,
                  ),
                  title: Text(user['name'] as String),
                  subtitle: const Text("Student"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 12,
                        color: user['status'] as bool
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(user['status'] as bool ? "Online" : "Offline"),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildPeakTimeCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Peak Time",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Students Online",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            "85",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: CustomPaint(
              painter: _LineChartPainter(context),
              child: Container(),
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
        Get.toNamed(Routes.ADMIN_LESSON_MANAGEMENT);
        break;
      case 7:
        // TODO: Implement edit lesson functionality
        break;
      case 8:
        Get.toNamed(Routes.QUIZ_MANAGEMENT);
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

// ---------------- SIMPLE LINE CHART ----------------

class _LineChartPainter extends CustomPainter {
  final BuildContext context;
  _LineChartPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Theme.of(context).colorScheme.onSurface
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Axes
    canvas.drawLine(
      const Offset(40, 0),
      Offset(40, size.height - 30),
      axisPaint,
    ); // Y
    canvas.drawLine(
      Offset(40, size.height - 30),
      Offset(size.width, size.height - 30),
      axisPaint,
    ); // X

    final drawText = (String text, double x, double y) {
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(x, y));
    };

    final yLabels = [20, 40, 60, 80, 100, 120];
    // Increase available height by reducing bottom padding
    double availableHeight = size.height - 80; // More space for distribution
    // Add extra spacing between labels
    double spacing = availableHeight / (yLabels.length - 0.5); // Increased gaps

    // Starting position with more padding from bottom
    double startY = size.height - 40;

    for (int i = 0; i < yLabels.length; i++) {
      double y =
          startY - (i * spacing * 1.2); // Multiply by 1.2 for 20% more gap
      drawText("${yLabels[i]}", 5, y - 6);
      // Longer tick marks for better visibility
      canvas.drawLine(Offset(32, y), Offset(40, y), axisPaint);
    }

    for (int i = 1; i <= 6; i++) {
      double x = 40 + (i * (size.width - 60) / 6);
      drawText("${i}h", x - 10, size.height - 25);
      canvas.drawLine(
        Offset(x, size.height - 30),
        Offset(x, size.height - 25),
        axisPaint,
      );
    }

    final path = Path();
    // Adjust scale factor to match the new y-axis spacing
    double graphHeight = startY - (yLabels.length - 1) * spacing * 1.2;
    double scale =
        (startY - graphHeight) / 120.0; // Scale factor based on new spacing

    // Data points (value, time) pairs
    final points = [
      (40.0, 0), // 0h, 40 students
      (60.0, 1), // 1h, 60 students
      (50.0, 2), // 2h, 50 students
      (80.0, 3), // 3h, 80 students
      (60.0, 4), // 4h, 60 students
      (100.0, 5), // 5h, 100 students
    ];

    // Draw the path
    bool first = true;
    for (var point in points) {
      double x = 40 + point.$2 * (size.width - 60) / 5;
      double y = size.height - 30 - (point.$1 * scale);

      if (first) {
        path.moveTo(x, y);
        first = false;
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
