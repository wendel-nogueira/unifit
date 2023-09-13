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

Future<void> auth(String email, String password, int type) async {
  if (email.isEmpty || password.isEmpty) {
    showAlert('campos inválidos', 'preencha todos os campos!', 'error');
    return;
  }

  if (!GetUtils.isEmail(email)) {
    showAlert('email inválido',
        'o email informado não é válido, por favor, tente novamente!', 'error');
    return;
  }

  const Map<int, String> endpointAuthType = {
    0: 'login-aluno', // 0 = aluno
    1: 'login-professor', // 1 = professor
    2: 'login-aluno', // 2 = tec. adm.
  };

  String api = '$endpoint/${endpointAuthType[type]}';
  Map<String, String> body = {'email': email, 'password': password};

  showLoading();

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

    hideLoading();
    showAlert('sucesso', 'autenticação realizada com sucesso!', 'success');

    Get.put(accountController);
    Get.offAllNamed('/home');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', accountController.token!);
    prefs.setInt('type', accountController.type!);

    if (type == 0) {
      prefs.setString('user', json.encode(accountController.user?.toJson()));
    } else if (type == 1) {
      prefs.setString(
          'teacher', json.encode(accountController.teacher?.toJson()));
    } else if (type == 2) {
      prefs.setString(
          'admtech', json.encode(accountController.admtech?.toJson()));
    }

    return;
  } else if (response.statusCode == 401) {
    hideLoading();
    showAlert('erro de autenticação',
        'email ou senha incorretos, por favor, tente novamente!', 'error');
    return;
  } else if (response.statusCode == 500) {
    hideLoading();
    showAlert(
        'erro de conexão',
        'não foi possível conectar ao servidor, tente novamente mais tarde!',
        'error');
    return;
  }

  hideLoading();
  showAlert('erro desconhecido',
      'ocorreu um erro desconhecido, por favor, tente novamente!', 'error');
  return;
}
