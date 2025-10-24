import 'package:get/get.dart';

/// Small collection of form validation helpers used across the user app.
///
/// Each method returns a nullable error message string (the typical
/// Flutter `FormField` validator contract). Return `null` to indicate the
/// value is valid.
class FormValidationHelper {
  /// Validates an email address. Returns an error message when invalid.
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email cannot be empty";
    }
    if (!GetUtils.isEmail(email)) {
      return "Invalid email format";
    }
    return null;
  }

  /// Validates a phone number using GetX `GetUtils.isPhoneNumber`.
  ///
  /// Note: the project accepts the GetUtils definition; adjust if you need
  /// stricter/locale-aware validation later.
  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return "Phone number cannot be empty";
    }
    if (!GetUtils.isPhoneNumber(phone)) {
      return "Invalid phone number format";
    }
    return null;
  }

  /// Basic password rules: non-empty and at least 8 characters.
  /// Extend this to include complexity rules (symbols, numbers) if needed.
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
