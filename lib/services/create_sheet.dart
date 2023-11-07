import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

import '../models/sheet.dart';

Future<int> createSheet(String token, Sheet sheet) async {
  String api = '$endpoint/ficha';
  Map<String, dynamic> body = sheet.toJson();

  var response = await http
      .post(
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
    showAlert('ficha criada', 'ficha criada com sucesso!', 'success');

    return 201;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return 401;
  } else {
    showAlert('erro ao criar a ficha',
        'não foi possível criar a ficha, tente novamente mais tarde!', 'error');

    return 500;
  }
}
