import 'dart:developer';

import 'package:get/get.dart';
import 'package:unifit/utils/alert.dart';

Future<void> verifyCode(String code) async {
  if (code.isEmpty) {
    showError('campos inválidos', 'preencha todos os campos!', 'error');
    return;
  }

  log('verificar código');
  Get.toNamed('/recovery-pass-tertiary');

  return;
}
