import 'package:flutter/material.dart';

// A simple sidebar used across admin pages. It shows admin profile
// information and a vertical list of menu actions. The widget is purely
// presentational — it invokes callbacks when an item is selected or when
// logout is requested.
class AdminSidebar extends StatelessWidget {
  final String adminName;
  final String adminRole;
  final String? adminAvatarUrl;
  final int selectedIndex;
  final void Function(int index) onMenuSelected;
  final VoidCallback onLogout;

  const AdminSidebar({
    Key? key,
    this.adminName = "Hello Admin",
    this.adminRole = "Administrator",
    this.adminAvatarUrl =
        "https://cdn-icons-png.flaticon.com/512/6833/6833605.png",
    required this.selectedIndex,
    required this.onMenuSelected,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 250,
      color: colorScheme.primary,
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Admin Info (avatar, name and role)
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(adminAvatarUrl!),
            backgroundColor: colorScheme.onPrimary,
          ),
          const SizedBox(height: 10),
          Text(
            adminName,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: colorScheme.onPrimary),
          ),
          Text(
            adminRole,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 40),
          // Menu Items: each menu item uses the private _SidebarMenuItem
          // widget. The selectedIndex determines which item appears active.
          _SidebarMenuItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            active: selectedIndex == 0,
            onTap: () => onMenuSelected(0),
          ),
          _SidebarMenuItem(
            icon: Icons.people,
            title: 'User Management',
            active: selectedIndex == 1,
            onTap: () => onMenuSelected(1),
          ),
          _SidebarMenuItem(
            icon: Icons.person,
            title: 'Unlock Content',
            active: selectedIndex == 2,
            onTap: () => onMenuSelected(2),
          ),
          _SidebarMenuItem(
            icon: Icons.book,
            title: 'Subject Management',
            active: selectedIndex == 3,
            onTap: () => onMenuSelected(3),
          ),
          _SidebarMenuItem(
            icon: Icons.video_library,
            title: 'Create Lesson',
            active: selectedIndex == 6,
            onTap: () => onMenuSelected(6),
          ),
          _SidebarMenuItem(
            icon: Icons.edit_note,
            title: 'Edit Lesson',
            active: selectedIndex == 7,
            onTap: () => onMenuSelected(7),
          ),
          _SidebarMenuItem(
            icon: Icons.quiz,
            title: 'Create Quiz',
            active: selectedIndex == 8,
            onTap: () => onMenuSelected(8),
          ),
          _SidebarMenuItem(
            icon: Icons.payment,
            title: 'Transaction History',
            active: selectedIndex == 9,
            onTap: () => onMenuSelected(9),
          ),
          _SidebarMenuItem(
            icon: Icons.analytics,
            title: 'Performance Analysis',
            active: selectedIndex == 10,
            onTap: () => onMenuSelected(10),
          ),
          _SidebarMenuItem(
            icon: Icons.leaderboard,
            title: 'Student Rank Zone',
            active: selectedIndex == 11,
            onTap: () => onMenuSelected(11),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onLogout,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: colorScheme.onPrimary),
                  const SizedBox(width: 8),
                  Text(
                    "Logout",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Private helper widget used to render each item. Marked private (leading
// underscore) because it's only relevant to this file; it exposes a simple
// `active` flag and an `onTap` callback.
class _SidebarMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _SidebarMenuItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.active,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onPrimary, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
