import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/utils/alert.dart';
import 'package:unifit/views/home_screen.dart';
import 'package:unifit/views/login_screen.dart';
import 'package:unifit/views/new_anamnesis/new_anamnesis_screen.dart';
import 'package:unifit/views/new_physical_assessment/new_physical_assessment_screen.dart';
import 'package:unifit/views/physical_assessment_list/physical_assessment_list_screen.dart';
import 'package:unifit/views/recovery_pass/recovery_pass_primary.dart';
import 'package:unifit/views/recovery_pass/recovery_pass_secondary.dart';
import 'package:unifit/views/recovery_pass/recovery_pass_tertiary.dart';
import 'package:unifit/views/user_list/user_list_screen.dart';
import 'package:unifit/views/user_profile/user_profile_screen.dart';
import 'package:unifit/views/view_physical_assessment/view_physical_assessment.dart';

const transitionDuration = Duration(milliseconds: 500);

List<GetPage> appRoutes() => [
      GetPage(
        name: '/login',
        page: () => const LoginPage(),
        transition: Transition.rightToLeftWithFade,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/recovery-pass-primary',
        page: () => const RecoveryPassPrimaryPage(),
        middlewares: [RouteName()],
        transition: Transition.rightToLeftWithFade,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/recovery-pass-secondary',
        page: () => const RecoveryPassSecondaryPage(),
        middlewares: [RouteName()],
        transition: Transition.rightToLeftWithFade,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/recovery-pass-tertiary',
        page: () => const RecoveryPassTertiaryPage(),
        middlewares: [RouteName()],
        transition: Transition.rightToLeftWithFade,
        transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/home',
        page: () => const HomePage(),
        middlewares: [AuthMiddleware(), RouteName()],
        //transition: Transition.rightToLeftWithFade,
        //transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/students-list',
        page: () => const UserListScreen(),
        middlewares: [AuthMiddleware(), RouteName()],

        //transition: Transition.leftToRightWithFade,
        //transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/profile',
        page: () => const UserProfileScreen(),
        middlewares: [AuthMiddleware(), RouteName()],
        //transition: Transition.leftToRightWithFade,
        //transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/user-physical-assessments/:id',
        page: () => const PhysicalAssessmentList(),
        middlewares: [AuthMiddleware(), RouteName()],
        //transition: Transition.leftToRightWithFade,
        //transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/view-physical-assessments',
        page: () => const ViewPhysicalAssessmentScreen(),
        middlewares: [AuthMiddleware(), RouteName()],
        //transition: Transition.leftToRightWithFade,
        //transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/new-physical-assessments/:id',
        page: () => const NewPhysicalAssessmentScreen(),
        middlewares: [AuthMiddleware(), RouteName()],
        //transition: Transition.leftToRightWithFade,
        //transitionDuration: transitionDuration,
      ),
      GetPage(
        name: '/new-user-anamnesis/:id',
        page: () => const NewAnamnesisScreen(),
        middlewares: [AuthMiddleware(), RouteName()],
        //transition: Transition.leftToRightWithFade,
        //transitionDuration: transitionDuration,
      ),
    ];

class RouteName extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    log(page?.name.toString() ?? '');
    return super.onPageCalled(page);
  }
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    try {
      AccountController user = Get.find<AccountController>();
      bool isAuth = user.isAuth;

      log(user.token.toString());
      if (isAuth) {
        return null;
      } else {
        showAlert(
          'Sessão expirada',
          'Sua sessão expirou, por favor faça login novamente.',
          'error',
        );

        return const RouteSettings(name: '/login');
      }
    } catch (e) {
      return const RouteSettings(name: '/login');
    }
  }
}
