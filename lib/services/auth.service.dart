import 'dart:developer';

import 'package:get/get.dart';
import 'package:unifit/utils/alert.dart';

Future<void> auth(String email, String password, int type) async {
  if (email.isEmpty || password.isEmpty) {
    showError('campos inválidos', 'preencha todos os campos!', 'error');
    return;
  }

  if (!GetUtils.isEmail(email)) {
    showError('email inválido',
        'o email informado não é válido, por favor, tente novamente!', 'error');
    return;
  }

  log('email: $email');
  log('password: $password');
  log('type: $type');

  return;
}
