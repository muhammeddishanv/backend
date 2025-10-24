import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ToastHelper extends GetxService {
  static const int _defaultDuration = 3000;

  void showSuccess(String message, {int duration = _defaultDuration}) {
    Fluttertoast.showToast(
      msg: message,
      textColor: Get.theme.colorScheme.onSurface,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration ~/ 1000,
      backgroundColor: Get.theme.colorScheme.primary,
    );
  }

  void showError(String message, {int duration = _defaultDuration}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Get.theme.colorScheme.error,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration ~/ 1000,
    );
  }

  void showInfo(String message, {int duration = _defaultDuration}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: const Color.fromARGB(255, 225, 240, 252),
      textColor: Get.theme.colorScheme.onSurface,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration ~/ 1000,
    );
  }

  void showWarning(String message, {int duration = _defaultDuration}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: const Color.fromARGB(255, 255, 237, 210),
      textColor: Get.theme.colorScheme.onSurface,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration ~/ 1000,
    );
  }
}
