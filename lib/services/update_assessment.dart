import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> updateAssessment(String token, int id, double peso) async {
  String api = '$endpoint/avaliacao';

  Map<String, dynamic> body = {
    'id': id.toString(),
    'peso': peso.toString(),
  };

  var response = await http
      .patch(
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

  if (response.statusCode == 200) {
    showAlert('peso atualizado', 'peso atualizado com sucesso!', 'success');

    return 200;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return 401;
  } else {
    showAlert(
        'erro ao atualizar peso',
        'não foi possível atualizar o peso, tente novamente mais tarde!',
        'error');

    return 500;
  }
}
