import 'package:get/get.dart';

import '../global_widgets/unknown_view.dart';
import '../modules/admin_create_lesson/bindings/admin_create_lesson_binding.dart';
import '../modules/admin_create_lesson/views/admin_create_lesson_view.dart';
import '../modules/admin_create_quiz/bindings/admin_create_quiz_binding.dart';
import '../modules/admin_create_quiz/views/admin_create_quiz_view.dart';
import '../modules/admin_create_subject/bindings/admin_create_subject_binding.dart';
import '../modules/admin_create_subject/views/admin_create_subject_view.dart';
import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/admin_edit_lesson/bindings/admin_edit_lesson_binding.dart';
import '../modules/admin_edit_lesson/views/admin_edit_lesson_view.dart';
import '../modules/admin_edit_subject/bindings/admin_edit_subject_binding.dart';
import '../modules/admin_edit_subject/views/admin_edit_subject_view.dart';
import '../modules/admin_performance_analysis/bindings/admin_performance_analysis_binding.dart';
import '../modules/admin_performance_analysis/views/admin_performance_analysis_view.dart';
import '../modules/admin_students_rank_zone/bindings/admin_students_rank_zone_binding.dart';
import '../modules/admin_students_rank_zone/views/admin_students_rank_zone_view.dart';
import '../modules/admin_subject_management/bindings/admin_subject_management_binding.dart';
import '../modules/admin_subject_management/views/admin_subject_management_view.dart';
import '../modules/admin_transaction_history/bindings/admin_transaction_history_binding.dart';
import '../modules/admin_transaction_history/views/admin_transaction_history_view.dart';
import '../modules/admin_user_details/bindings/admin_user_details_binding.dart';
import '../modules/admin_user_details/views/admin_user_details_view.dart';
import '../modules/admin_user_management/bindings/admin_user_management_binding.dart';
import '../modules/admin_user_management/views/admin_user_management_view.dart';
import '../modules/signin_screen/signin/bindings/signin_screen_signin_binding.dart';
import '../modules/signin_screen/signin/views/signin_screen_signin_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Set a concrete initial route to a real page.
  static const INITIAL = _Paths.SIGNIN_SCREEN_SIGNIN;

  static final routes = [
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_TRANSACTION_HISTORY,
      page: () => AdminTransactionHistoryView(),
      binding: AdminTransactionHistoryBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_USER_DETAILS,
      page: () => AdminUserDetailsView(),
      binding: AdminUserDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_USER_MANAGEMENT,
      page: () => AdminUserManagementView(),
      binding: AdminUserManagementBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PERFORMANCE_ANALYSIS,
      page: () => AdminPerformanceAnalysisView(),
      binding: AdminPerformanceAnalysisBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_STUDENTS_RANK_ZONE,
      page: () => AdminStudentsRankZoneView(),
      binding: AdminStudentsRankZoneBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_SUBJECT_MANAGEMENT,
      page: () => AdminSubjectManagementView(),
      binding: AdminSubjectManagementBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_CREATE_SUBJECT,
      page: () => AdminCreateSubjectView(),
      binding: AdminCreateSubjectBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_EDIT_SUBJECT,
      page: () => AdminEditSubjectView(),
      binding: AdminEditSubjectBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_CREATE_QUIZ,
      page: () => AdminCreateQuizView(),
      binding: AdminCreateQuizBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_EDIT_LESSON,
      page: () => AdminEditLessonView(),
      binding: AdminEditLessonBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_CREATE_LESSON,
      page: () => AdminCreateLessonView(),
      binding: AdminCreateLessonBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN_SCREEN_SIGNIN,
      page: () => SigninScreenSigninView(),
      binding: SigninScreenSigninBinding(),
    ),
  ];

  static final unknownRoute = GetPage(
    name: '/404',
    page: () => const UnknownView(),
  );
}
