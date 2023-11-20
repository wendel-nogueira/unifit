import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> updatePassword(String type, String newPassword, int id) async {
  String api = endpoint;

  if (type == 'aluno') {
    api += '/change-password-aluno/$id';
  } else if (type == 'professor') {
    api += '/change-password-professor/$id';
  } else if (type == 'admin') {
    api += '/change-password-tecnico/$id';
  }

  Map<String, dynamic> body = {
    'newPassword': newPassword,
  };

  var response = await http
      .post(
    Uri.parse(api),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: json.encode(body),
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
    showAlert('senha atualizada', 'senha atualizada com sucesso!', 'success');

    return 200;
  } else {
    showAlert(
        'erro ao atualizar senha',
        'não foi possível atualizar a senha, verifique os dados e tente novamente!',
        'error');

    return 500;
  }
}
