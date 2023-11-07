import 'dart:convert';

import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';
import 'package:http/http.dart' as http;

import '../models/sheet.dart';

Future<Sheet> getSheet(String token, int sheetId) async {
  String api = '$endpoint/ficha/$sheetId';

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

  Sheet sheet = Sheet();

  if (response.statusCode == 200) {
    dynamic body = json.decode(response.body);

    if (body != null && body.isNotEmpty) {
      sheet = Sheet.fromJson(body);
    }

    return sheet;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return sheet;
  } else {
    showAlert(
        'erro de conexão',
        'não foi possível conectar ao servidor, tente novamente mais tarde!',
        'error');

    return sheet;
  }
}
