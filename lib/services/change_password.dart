import 'package:get/get.dart';
import 'package:unifit/utils/alert.dart';

Future<void> changePassword(String newPassword, String repeatPassword) async {
  if (newPassword.isEmpty || repeatPassword.isEmpty) {
    showError('campos inválidos', 'preencha todos os campos!', 'error');
    return;
  }

  if (newPassword != repeatPassword) {
    showError(
        'senhas não coincidem!',
        'as senhas digitadas não coincidem, por favor, tente novamente!',
        'error');
    return;
  }

  Get.toNamed('/login');

  return;
}
