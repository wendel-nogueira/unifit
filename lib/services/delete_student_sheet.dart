import 'dart:convert';

import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';
import 'package:http/http.dart' as http;

Future<void> deleteStudentSheet(
    String token, int studentId, int sheetId) async {
  String api = '$endpoint/ficha_aluno/$studentId/$sheetId';

  var response = await http.delete(Uri.parse(api), headers: {
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

  if (response.statusCode == 200) {
    showAlert('ficha removida', 'ficha removida com sucesso!', 'success');
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');
  } else {
    showAlert(
        'erro ao remover a ficha',
        'não foi possível remover a ficha, tente novamente mais tarde!',
        'error');
  }
}
