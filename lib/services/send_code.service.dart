import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> sendCode(String email, String code) async {
  String api = '$endpoint/send-reset-password-email';

  Map<String, dynamic> body = {
    'email': email,
    'code': code,
  };

  var response = await http
      .post(
    Uri.parse(api),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    },
    body: body,
  )
      .timeout(
    const Duration(seconds: 20),
    onTimeout: () {
      showAlert(
          'erro de conexão',
          'não foi possível conectar ao servidor, tente novamente mais tarde!',
          'error');

      http.Response response = http.Response('erro de conexão', 500);

      return Future.value(response);
    },
  );

  if (response.statusCode == 200) {
    showAlert('email enviado', 'verifique seu email!', 'success');

    return 200;
  } else {
    showAlert(
        'erro ao enviar email',
        'não foi possível enviar o email, verifique os dados e tente novamente!',
        'error');

    return 500;
  }
}
