import 'package:get/get.dart';

import '../modules/auth/auth.binding.dart';
import '../modules/auth/auth.view.dart';
import '../modules/home/home.binding.dart';
import '../modules/home/home.view.dart';
import '../modules/lesson/lesson.binding.dart';
import '../modules/lesson/lesson.view.dart';
import '../modules/not_found/not_found.binding.dart';
import '../modules/not_found/not_found.view.dart';
import '../modules/payment/payment.binding.dart';
import '../modules/payment/payment.view.dart';
import '../modules/quiz/quiz.binding.dart';
import '../modules/quiz/quiz.view.dart';
import '../modules/splash/splash.binding.dart';
import '../modules/splash/splash.view.dart';
import '../modules/store/store.binding.dart';
import '../modules/store/store.view.dart';
import '../modules/student/change_password/change_password.binding.dart';
import '../modules/student/change_password/change_password.view.dart';
import '../modules/student/edit_profile/edit_profile.binding.dart';
import '../modules/student/edit_profile/edit_profile.view.dart';
import '../modules/student/history/history.binding.dart';
import '../modules/student/history/history.view.dart';
import '../modules/student/performance/performance.binding.dart';
import '../modules/student/performance/performance.view.dart';
import '../modules/subject_details/subject_details.binding.dart';
import '../modules/subject_details/subject_details.view.dart';
import 'middleware/auth_middleware.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final unknownRoute = GetPage(
    name: _Paths.NOT_FOUND,
    page: () => const NotFoundView(),
    binding: NotFoundBinding(),
  );

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
     // middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.COURSE_DETAILS,
      page: () => SubjectDetailsView(),
      binding: CourseDetailsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.QUIZ,
      page: () => QuizView(),
      binding: QuizBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PAYMENT,
      page: () => PaymentView(),
      binding: PaymentBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.PERFORMANCE,
      page: () => PerformanceView(),
      binding: PerformanceBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () =>  HistoryView(),
      binding: HistoryBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.STORE,
      page: () => StoreView(),
      binding: StoreBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.LESSON,
      page: () => LessonView(),
      binding: LessonBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
