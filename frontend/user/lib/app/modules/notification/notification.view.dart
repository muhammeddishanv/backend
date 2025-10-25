import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../global_widgets/notification_card.dart';
import 'notification_detail.view.dart';

class NotificationsView extends GetResponsiveView {
  NotificationsView({Key? key}) : super(key: key, alwaysUseBuilder: false);

  final List<Map<String, String>> notifications = [
    {
      'title': 'Password change alerts',
      'subtitle': 'Your password was successfully updated',
    },
    {
      'title': 'Profile completion reminders',
      'subtitle': 'Add your profile picture to complete your account',
    },
  ];

  @override
  Widget? phone() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(Get.context!).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(Get.context!).colorScheme.onPrimary,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Theme.of(Get.context!).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: _buildFilterChips().paddingOnly(bottom: 16),
        ),
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final title = notifications[index]['title']!;
          final subtitle = notifications[index]['subtitle']!;
          return NotificationCard(
            title: title,
            subtitle: subtitle,
            icon: Icons.notifications,
            onTap: () => Get.to(
              () => NotificationDetailView(title: title, subtitle: subtitle),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget? tablet() {
    return phone();
  }

  @override
  Widget? desktop() {
    return phone();
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 16),
          _buildFilterChip('All', Icons.list, isSelected: true),
          _buildFilterChip('Unread', null, isSelected: false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData? icon, {
    required bool isSelected,
  }) {
    final theme = Theme.of(Get.context!);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: RawChip(
        avatar: icon != null
            ? Icon(icon, size: 18, color: theme.colorScheme.onBackground)
            : null,
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onBackground,
          ),
        ),
        backgroundColor: isSelected
            ? theme.colorScheme.background
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
