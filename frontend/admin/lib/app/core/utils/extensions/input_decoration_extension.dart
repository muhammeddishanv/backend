import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
