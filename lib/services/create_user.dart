import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> createUser(String token, String type, dynamic user) async {
  String api = endpoint;

  if (type == 'student') {
    api += '/alunos';
  } else if (type == 'teacher') {
    api += '/professor';
  } else if (type == 'tecadm') {
    api += '/tecadm';
  }

  Map<String, dynamic> body = user.toJson();

  var response = await http
      .post(
    Uri.parse(api),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
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

  if (response.statusCode == 201) {
    showAlert('usuário criado', 'usuário criado com sucesso!', 'success');

    return 201;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return 401;
  } else {
    showAlert(
        'erro ao criar usuário',
        'não foi possível criar o usuário, verifique os dados e tente novamente!',
        'error');

    return 500;
  }
}
