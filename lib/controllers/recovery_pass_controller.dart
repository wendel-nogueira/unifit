import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/send_code.service.dart';

class RecoveryPassController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RecoveryPassController({this.email, this.code, this.type});

  String? email;
  String? code;
  int? type = 0;

  void generateCode() {
    const allowedChars = '0123456789';
    var code = '';

    var random = Random();

    for (var i = 0; i < 4; i++) {
      code += allowedChars[random.nextInt(allowedChars.length)];
    }

    this.code = code;
  }

  void sendEmail(String email, int type) {
    if (email.isEmpty) {
      Get.snackbar('campos inválidos', 'preencha todos os campos!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    this.email = email;
    this.type = type;
    generateCode();

    sendCode(email, code!);
  }
}
