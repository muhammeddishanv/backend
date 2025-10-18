import 'package:flutter/material.dart';

import 'package:get/get.dart';

/// A reusable search bar widget with sensible defaults and configurable behavior.
///
/// You can customize:
/// - hint text & style colors
/// - callbacks (onChanged, onSubmitted, onSearchPressed)
/// - controller / focusNode
/// - icons (prefix / suffix) or fall back to a tappable search icon
/// - visual parameters (radius, background color, padding)
/// - text input configuration
///
/// Layout is NOT forced; wrap with [Expanded] / [SizedBox] outside if needed.
class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onSearchPressed,
    this.hintText = 'Search...',
    this.padding,
    this.borderRadius = 20,
    this.backgroundColor,
    this.hintColor,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.textInputAction = TextInputAction.search,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.enabled = true,
    this.outlined = false,
    this.cursorAndTextColor,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchPressed;
  final String hintText;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? hintColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool autofocus;
  final bool enabled;
  final bool outlined;
  final Color? cursorAndTextColor;

  Color _resolveBg(ColorScheme scheme) =>
      backgroundColor ?? scheme.primaryContainer.withAlpha(50);

  Color _resolveHint(ColorScheme scheme) =>
      hintColor ?? scheme.onPrimary.withOpacity(0.7);

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme; // using GetX-provided theme
    final colorScheme = theme.colorScheme;

    final textField = TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: (value) {
        onSubmitted?.call(value);
        // If user presses the keyboard action button, treat like search.
        if (onSearchPressed != null) onSearchPressed!();
      },
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      readOnly: readOnly,
      autofocus: autofocus,
      enabled: enabled,
      // Ensure the actual input (typed text) uses onPrimary color as requested.
      style: TextStyle(color: cursorAndTextColor ?? colorScheme.onPrimary),
      cursorColor: cursorAndTextColor ?? colorScheme.onPrimary,
      decoration: InputDecoration(
        isDense: false,
        hintText: hintText,

        hintStyle: TextStyle(color: _resolveHint(colorScheme)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: outlined
              ? BorderSide(color: colorScheme.onSurface, width: 1)
              : BorderSide.none,
        ),
        filled: true,
        counterStyle: TextStyle(color: colorScheme.onPrimary),
        fillColor: _resolveBg(colorScheme),
        labelStyle: TextStyle(color: colorScheme.onPrimary),
        prefixIcon:
            prefixIcon ??
            IconButton(
              splashRadius: 18,
              icon: Icon(Icons.search, color: colorScheme.onPrimary),
              onPressed: onSearchPressed,
            ),
        suffixIcon: suffixIcon,
      ),
    );

    if (padding != null) {
      return Padding(padding: padding!, child: textField);
    }
    return textField;
  }
}
