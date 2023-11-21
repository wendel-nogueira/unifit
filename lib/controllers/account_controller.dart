import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifit/models/user.dart';
import 'package:unifit/models/teacher.dart';
import 'package:unifit/models/adm_tech.dart';

class AccountController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AccountController(
      {this.token, this.type, this.user, this.teacher, this.admtech});

  String? token;
  int? type;
  User? user;
  Teacher? teacher;
  AdmTech? admtech;
  bool get isAuth => token != null && !JwtDecoder.isExpired(token!);

  late TabController tabController;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void logout() {
    token = null;
    type = null;
    user = null;
    teacher = null;
    admtech = null;

    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
      prefs.remove('type');
      prefs.remove('user');
      prefs.clear();
    });

    Get.offAllNamed('/login');
  }
}
