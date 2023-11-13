import 'dart:convert';

import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';
import 'package:http/http.dart' as http;

Future<void> deleteTeacher(String token, int teacherId) async {
  String api = '$endpoint/professor/$teacherId';

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
    showAlert(
        'professor excluído', 'professor excluído com sucesso!', 'success');
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');
  } else {
    showAlert(
        'erro ao excluir o professor',
        'não foi possível excluir o professor, tente novamente mais tarde!',
        'error');
  }
}
