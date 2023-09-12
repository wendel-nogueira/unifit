import 'dart:developer';

import 'package:get/get.dart';
import 'package:unifit/views/login_screen.dart';
import 'package:unifit/views/recovery_pass/recovery_pass_primary.dart';
import 'package:unifit/views/recovery_pass/recovery_pass_secondary.dart';
import 'package:unifit/views/recovery_pass/recovery_pass_tertiary.dart';

const transitionDuration = Duration(milliseconds: 300);

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
    ];

class RouteName extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    log(page?.name.toString() ?? '');
    return super.onPageCalled(page);
  }
}
