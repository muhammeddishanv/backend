import 'package:flutter/material.dart';

import 'package:get/get.dart';

/// A reusable top bar container with a rounded bottom edge and optional styling.
///
/// Provide a [child] for full custom layout. Common visual properties can be
/// overridden via constructor parameters (colors, gradient, radii, padding, shadow).
///
/// Example:
/// CustomTopBar(
///   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
///   child: Row(children:[BackButton(), const Spacer(), Text('Title')]),
/// )
class CustomTopBar extends StatelessWidget {
  const CustomTopBar({
    super.key,
    required this.child,
    this.backgroundColor,
    this.gradient,
    this.bottomLeftRadius = 50,
    this.bottomRightRadius = 50,
    this.padding,
    this.boxShadow,
    this.safeArea = true,
    this.clipBehavior = Clip.hardEdge,
  });

  /// Content placed inside the decorated container.
  final Widget child;

  /// Override the background color (ignored if [gradient] is provided).
  final Color? backgroundColor;

  /// Optional gradient background. Takes precedence over [backgroundColor].
  final Gradient? gradient;

  /// Bottom left corner radius.
  final double bottomLeftRadius;

  /// Bottom right corner radius.
  final double bottomRightRadius;

  /// Padding applied around [child].
  final EdgeInsetsGeometry? padding;

  /// Optional box shadows.
  final List<BoxShadow>? boxShadow;

  /// Wraps content in a SafeArea (top only) when true.
  final bool safeArea;

  /// Clip behavior for the container (defaults to [Clip.hardEdge]).
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final color = backgroundColor ?? theme.colorScheme.primary;
    final content = Padding(padding: padding ?? EdgeInsets.zero, child: child);

    Widget inner = Container(
      width: double.infinity,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeftRadius),
          bottomRight: Radius.circular(bottomRightRadius),
        ),
        boxShadow: boxShadow,
      ),
      child: content,
    );

    if (safeArea) {
      inner = SafeArea(top: true, bottom: false, child: inner);
    }
    return inner;
  }
}
