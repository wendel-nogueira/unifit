import 'dart:convert';

import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifit/controllers/account_controller.dart';

import '../models/adm_tech.dart';
import '../models/teacher.dart';
import '../models/user.dart';

verifyAuth() async {
  SharedPreferences.getInstance().then((prefs) {
    String token = prefs.getString('token') ?? '';
    Get.find<AccountController>().token = token;

    int type = prefs.getInt('type') ?? -1;
    Get.find<AccountController>().type = type;

    String user = prefs.getString('user') ?? '';

    bool tokenIsValid = token.isNotEmpty && !JwtDecoder.isExpired(token);

    if (type != -1 &&
        token.isNotEmpty &&
        user.isNotEmpty &&
        user != 'null' &&
        tokenIsValid) {
      if (type == 0) {
        Get.find<AccountController>().user = User.fromJson(json.decode(user));
        Get.offNamed('/my-sheets');
      } else if (type == 1) {
        Get.find<AccountController>().teacher =
            Teacher.fromJson(json.decode(user));
        Get.offNamed('/students-list');
      } else if (type == 2) {
        Get.find<AccountController>().admtech =
            AdmTech.fromJson(json.decode(user));
        Get.offNamed('/students-list');
      }
    }
  });
}
