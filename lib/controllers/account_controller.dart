import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unifit/models/user.dart';
import 'package:unifit/models/teacher.dart';
import 'package:unifit/models/adm_tech.dart';

class AccountController extends GetxController
    with GetSingleTickerProviderStateMixin {
  AccountController(
      {required this.token,
      required this.type,
      this.user,
      this.teacher,
      this.admtech});

  String token;
  final int type;
  final User? user;
  final Teacher? teacher;
  final AdmTech? admtech;

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
}
