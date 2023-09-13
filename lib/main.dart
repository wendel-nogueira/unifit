import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/adm_tech.dart';
import 'package:unifit/models/teacher.dart';
import 'package:unifit/models/user.dart';
import 'package:unifit/routes.dart';
import 'package:unifit/utils/alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UniFit',
      initialRoute: '/login',
      getPages: appRoutes(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onInit: () {
        Get.put(AccountController());

        SharedPreferences.getInstance().then((prefs) {
          Get.find<AccountController>().token = prefs.getString('token');

          int type = prefs.getInt('type') ?? -1;
          Get.find<AccountController>().type = type;

          String user = prefs.getString('user') ?? '';

          if (type == 0 && user.isNotEmpty) {
            Get.find<AccountController>().user =
                User.fromJson(json.decode(user));
          } else if (type == 1 && user.isNotEmpty) {
            Get.find<AccountController>().teacher =
                Teacher.fromJson(json.decode(user));
          } else if (type == 2 && user.isNotEmpty) {
            Get.find<AccountController>().admtech =
                AdmTech.fromJson(json.decode(user));
          }

          if (Get.find<AccountController>().isAuth) {
            Get.offNamed('/home');
          }
        });
      },
    );
  }
}
