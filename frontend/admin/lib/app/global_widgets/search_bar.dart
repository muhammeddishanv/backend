import 'package:flutter/material.dart';

// Lightweight search input used in the admin header/sidebar. It exposes an
// `onChanged` callback for the parent to react to user input and accepts an
// optional TextEditingController for external control/reset.
class AdminSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  final TextEditingController? controller;

  const AdminSearchBar({
    Key? key,
    required this.onChanged,
    this.hintText = "Search",
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
