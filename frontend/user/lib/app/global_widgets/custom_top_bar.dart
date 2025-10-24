import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A reusable top bar with rounded bottom corners and custom child content.
class CustomTopBar extends StatelessWidget {
  const CustomTopBar({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final color = backgroundColor ?? Get.theme.colorScheme.primary;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
      ),
      child: child,
    );
  }
}
