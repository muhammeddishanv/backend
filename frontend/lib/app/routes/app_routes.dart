// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const AUTH = _Paths.AUTH;
  static const COURSE_DETAILS = _Paths.COURSE_DETAILS;
  static const QUIZ = _Paths.QUIZ;
  static const PAYMENT = _Paths.PAYMENT;
  static const SPLASH = _Paths.SPLASH;
  static const PERFORMANCE = _Paths.STUDENT + _Paths.PERFORMANCE;
  static const HISTORY = _Paths.STUDENT + _Paths.HISTORY;
  static const STORE = _Paths.STORE;
  static const CHANGE_PASSWORD = _Paths.STUDENT + _Paths.CHANGE_PASSWORD;
  static const EDIT_PROFILE = _Paths.STUDENT + _Paths.EDIT_PROFILE;
  static const LESSON = _Paths.LESSON;
  static const NOT_FOUND = _Paths.NOT_FOUND;
  static const CONTACT_US = _Paths.HOME + _Paths.CONTACT_US;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const AUTH = '/auth';
  static const COURSE_DETAILS = '/course-details';
  static const QUIZ = '/quiz';
  static const PAYMENT = '/payment';
  static const SPLASH = '/splash';
  static const PERFORMANCE = '/performance';
  static const STUDENT = '';
  static const HISTORY = '/history';
  static const STORE = '/store';
  static const CHANGE_PASSWORD = '/change-password';
  static const EDIT_PROFILE = '/edit-profile';
  static const LESSON = '/lesson';
  static const NOT_FOUND = '/not-found';
  static const CONTACT_US = '/contact-us';
}
