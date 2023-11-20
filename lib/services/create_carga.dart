import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> createCarga(
    String token, int studentId, int idexercicio, int carga) async {
  String api = '$endpoint/carga';

  Map<String, dynamic> body = {
    'idexercicio': idexercicio.toString(),
    'idaluno': studentId.toString(),
    'carga': carga.toString(),
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

  if (response.statusCode == 201) {
    showAlert('carga registrada', 'carga registrada com sucesso!', 'success');

    return 201;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return 401;
  } else {
    showAlert(
        'erro ao registrar carga',
        'não foi possível registrar a carga, verifique os dados e tente novamente!',
        'error');

    return 500;
  }
}
