import 'package:flutter/material.dart';

import 'package:get/get.dart';

/// Centralized input decoration used across the app's forms.
///
/// Returns an [InputDecoration] configured with the project's default
/// look-and-feel (label style, hint style, border radius and padding).
/// The helper uses `Get.theme` so it adapts to the current theme.
InputDecoration inputDecoration(String label, {String hint = ''}) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Get.theme.hintColor, fontSize: 16),
    hintText: hint,
    hintStyle: TextStyle(color: Get.theme.hintColor),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}
