import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> createFrequency(String token, int studentId, int admId) async {
  String api = '$endpoint/frequencia';

  Map<String, dynamic> body = {
    'idservico': 1.toString(),
    'idaluno': studentId.toString(),
    'idta': admId.toString(),
  };

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

  if (response.statusCode == 200) {
    showAlert(
        'presença registrada', 'presença registrada com sucesso!', 'success');

    return 200;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return 401;
  } else if (response.statusCode == 403) {
    showAlert('não autorizado',
        'este aluno não está matriculado neste serviço!', 'error');

    return 403;
  } else {
    showAlert(
        'erro ao registrar presença',
        'não foi possível registrar a presença, verifique os dados e tente novamente!',
        'error');

    return 500;
  }
}
