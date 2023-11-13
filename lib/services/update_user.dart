import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> updateUser(String token, String type, dynamic user, int id) async {
  String api = endpoint;

  if (type == 'student') {
    api += '/alunos/$id';
  } else if (type == 'teacher') {
    api += '/professor/$id';
  } else if (type == 'tecadm') {
    api += '/tecadm/$id';
  }

  Map<String, dynamic> body = user.toJson();

  var response = await http
      .patch(
    Uri.parse(api),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
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
    showAlert(
        'usuário atualizado', 'usuário atualizado com sucesso!', 'success');

    return 201;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return 401;
  } else {
    showAlert(
        'erro ao atualizar usuário',
        'não foi possível atualizar o usuário, verifique os dados e tente novamente!',
        'error');

    return 500;
  }
}
