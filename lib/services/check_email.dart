import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:unifit/config/config.dart';

Future<dynamic> checkEmail(String email, String tipo) async {
  String api = '$endpoint/check-email';

  Map<String, dynamic> body = {
    'email': email,
    'tipo': tipo,
  };

  var response = await http
      .post(
        Uri.parse(api),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: body,
      )
      .timeout(
        const Duration(seconds: 20),
      );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    return null;
  }
}
