import 'package:get/get.dart';

class FormValidationHelper {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email cannot be empty";
    }
    if (!GetUtils.isEmail(email)) {
      return "Invalid email format";
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Phone number cannot be empty";
    }
    if (!GetUtils.isPhoneNumber(phone)) {
      return "Invalid phone number format";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password cannot be empty";
    }
    if (password.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }
}
