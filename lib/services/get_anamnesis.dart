import 'dart:convert';

import 'package:unifit/models/anamnesis.dart';
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';
import 'package:http/http.dart' as http;

Future<Anamnesis> getAnamnesis(String token, int studentId) async {
  String api = '$endpoint/anamnese/$studentId';

  var response = await http.get(Uri.parse(api), headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  }).timeout(
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

  Anamnesis anamnesis = Anamnesis();

  if (response.statusCode == 200) {
    dynamic body = json.decode(response.body);

    if (body != null && body.isNotEmpty) {
      anamnesis = Anamnesis.fromJson(body.last);
    }

    return anamnesis;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return anamnesis;
  } else {
    showAlert(
        'erro de conexão',
        'não foi possível conectar ao servidor, tente novamente mais tarde!',
        'error');

    return anamnesis;
  }
}
