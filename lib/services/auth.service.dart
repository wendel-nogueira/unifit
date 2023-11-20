import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/adm_tech.dart';
import 'package:unifit/models/teacher.dart';
import 'package:unifit/models/user.dart';
import 'package:unifit/utils/alert.dart';
import 'package:unifit/config/config.dart';

Future<void> auth(
    String email, String password, int type, BuildContext context) async {
  if (email.isEmpty || password.isEmpty) {
    showAlert('campos inválidos', 'preencha todos os campos!', 'error');
    return;
  }

  if (!GetUtils.isEmail(email)) {
    showAlert('email inválido',
        'o email informado não é válido, por favor, tente novamente!', 'error');
    return;
  }

  Dialog dialog = const Dialog(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) => dialog,
  );

  const Map<int, String> endpointAuthType = {
    0: 'login-aluno', // 0 = aluno
    1: 'login-professor', // 1 = professor
    2: 'login-tecnico', // 2 = tec. adm.
  };

  String api = '$endpoint/${endpointAuthType[type]}';
  Map<String, String> body = {'email': email, 'password': password};

  var response = await http
      .post(
    Uri.parse(api),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
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

  if (context.mounted) Navigator.pop(context);

  if (response.statusCode == 200) {
    dynamic body = json.decode(response.body);
    AccountController accountController = Get.find<AccountController>();

    accountController.token = body['token'];
    accountController.type = type;

    if (type == 0) {
      accountController.user = User.fromJson(body['user']);
    } else if (type == 1) {
      accountController.teacher = Teacher.fromJson(body['user']);
    } else if (type == 2) {
      accountController.admtech = AdmTech.fromJson(body['user']);
    }

    showAlert('sucesso', 'autenticação realizada com sucesso!', 'success');

    Get.put(accountController);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.clear();
    prefs.setString('token', accountController.token!);
    prefs.setInt('type', accountController.type!);
    prefs.setString(
        'user',
        json.encode(
          accountController.user != null
              ? accountController.user!.toJson()
              : accountController.teacher != null
                  ? accountController.teacher!.toJson()
                  : accountController.admtech!.toJson(),
        ));

    Get.put<SharedPreferences>(prefs);

    if (type == 0) {
      Get.offAllNamed('/my-sheets');
    } else if (type == 1) {
      Get.offAllNamed('/students-list');
    } else if (type == 2) {
      Get.offAllNamed('/students-list');
    }

    return;
  } else if (response.statusCode == 401) {
    showAlert('erro de autenticação',
        'email ou senha incorretos, por favor, tente novamente!', 'error');
    return;
  } else if (response.statusCode == 500) {
    showAlert(
        'erro de conexão',
        'não foi possível conectar ao servidor, tente novamente mais tarde!',
        'error');
    return;
  }

  showAlert('erro desconhecido',
      'ocorreu um erro desconhecido, por favor, tente novamente!', 'error');
  return;
}
