import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<int> sendFeedbackEmail(String token, String feedback) async {
  String api = '$endpoint/send-feedback-email';

  Map<String, dynamic> body = {
    'feedback': feedback,
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
    showAlert('feedback enviado', 'obrigado pelo seu feedback!', 'success');

    return 200;
  } else {
    showAlert(
        'erro ao enviar feedback',
        'não foi possível enviar o feedback, verifique os dados e tente novamente!',
        'error');

    return 500;
  }
}
