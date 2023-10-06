import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/models/anamnesis.dart';
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> createAnamnesis(
    String token, Anamnesis anamnesis, int studentId) async {
  String api = '$endpoint/anamnese';

  Map<String, dynamic> body = anamnesis.toJson(studentId);

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
    showAlert('anamnese criada', 'anamnese criada com sucesso!', 'success');

    return 200;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return 401;
  } else {
    showAlert(
        'erro de conexão',
        'não foi possível conectar ao servidor, tente novamente mais tarde!',
        'error');

    return 500;
  }
}
