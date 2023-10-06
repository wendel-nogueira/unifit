import 'dart:convert';

import 'package:unifit/models/assessment.dart';
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';
import 'package:http/http.dart' as http;

Future<List<Assessment>> getAssessment(String token, int studentId) async {
  String api = '$endpoint/avaliacao/$studentId';

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

  List<Assessment> assessments = [];

  if (response.statusCode == 200) {
    dynamic body = json.decode(response.body);

    body.forEach((element) {
      assessments.add(Assessment.fromJson(element));
    });

    return assessments;
  } else if (json.decode(response.body)['message'] ==
      'Token de autenticação inválido') {
    showAlert('sessão expirada',
        'sua sessão expirou, por favor, faça login novamente!', 'error');

    return assessments;
  } else {
    showAlert(
        'erro de conexão',
        'não foi possível conectar ao servidor, tente novamente mais tarde!',
        'error');

    return assessments;
  }
}
