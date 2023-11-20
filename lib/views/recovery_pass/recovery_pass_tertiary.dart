import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/button.dart';
import 'package:unifit/components/input.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/recovery_pass_controller.dart';
import 'package:unifit/services/update_password.dart';

import '../../models/adm_tech.dart';
import '../../models/teacher.dart';
import '../../models/user.dart';
import '../../services/check_email.dart';
import '../../utils/alert.dart';

class RecoveryPassTertiaryPage extends StatefulWidget {
  const RecoveryPassTertiaryPage({super.key});

  @override
  State<RecoveryPassTertiaryPage> createState() => _RecoveryPassTertiaryPage();
}

class _RecoveryPassTertiaryPage extends State<RecoveryPassTertiaryPage> {
  User user = User();
  Teacher teacher = Teacher();
  AdmTech admTech = AdmTech();
  bool loading = false;
  bool send = false;

  RecoveryPassController recoveryPassController =
      Get.find<RecoveryPassController>();
  String? type;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        type = recoveryPassController.type == 0
            ? 'aluno'
            : recoveryPassController.type == 1
                ? 'professor'
                : 'admin';

        loading = true;
        getInfo();
      });
    }
  }

  void getInfo() {
    var email = recoveryPassController.email!;

    checkEmail(email, type!).then(
      (value) => {
        if (value != null)
          {
            if (type == 'aluno')
              {
                setState(
                  () {
                    user = User.fromJson(value);

                    loading = false;
                  },
                ),
              }
            else if (type == 'professor')
              {
                setState(
                  () {
                    teacher = Teacher.fromJson(value);

                    loading = false;
                  },
                ),
              }
            else if (type == 'admin')
              {
                setState(
                  () {
                    admTech = AdmTech.fromJson(value);

                    loading = false;
                  },
                ),
              }
          }
        else
          {
            showAlert('erro', 'email não encontrado!', 'error'),
            Get.offAndToNamed('/login'),
          }
      },
    );
  }

  void sendRequest(String newPassword, String repeatPassword) async {
    if (newPassword.isEmpty || repeatPassword.isEmpty) {
      showAlert('campos inválidos', 'preencha todos os campos!', 'error');
      return;
    }

    if (newPassword.length < 8 || repeatPassword.length < 8) {
      showAlert('campos inválidos', 'a senha deve ter no mínimo 6 caracteres!',
          'error');
      return;
    }

    if (newPassword != repeatPassword) {
      showAlert('senhas diferentes', 'as senhas não coincidem!', 'error');
      return;
    }

    var id = type == 'aluno'
        ? user.idAluno
        : type == 'professor'
            ? teacher.idProfessor
            : admTech.idTecnicoAdministrativo;

    setState(() {
      send = true;
    });

    await updatePassword(type!, newPassword, id).then(
      (value) => {
        if (value == 200)
          {
            Get.offAndToNamed('/login'),
          },
        setState(() {
          send = false;
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String newPassword = '';
    String repeatPassword = '';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            bgColorBlueLightSecondary,
            bgColorBlueNormal,
          ],
        )),
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: !loading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'recuperação de senha',
                        style: GoogleFonts.roboto(
                          color: fontColorWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        textWidthBasis: TextWidthBasis.longestLine,
                      ),
                    ),
                    const SizedBox(height: defaultMarginMedium),
                    Center(
                      child: Text(
                        'informe sua nova senha!',
                        style: GoogleFonts.manrope(
                          color: fontColorWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        textWidthBasis: TextWidthBasis.longestLine,
                      ),
                    ),
                    const SizedBox(height: defaultMarginLarger),
                    InputPrimary(
                      hintText: 'senha',
                      type: 'password',
                      onChanged: (String value) {
                        newPassword = value;
                      },
                    ),
                    InputPrimary(
                      hintText: 'repita a senha',
                      type: 'password',
                      onChanged: (String value) {
                        repeatPassword = value;
                      },
                    ),
                    const SizedBox(height: defaultMarginLarge),
                    ButtonPrimary(
                      hintText: 'alterar senha',
                      disabled: send,
                      onPressed: () {
                        sendRequest(newPassword, repeatPassword);
                      },
                    ),
                  ],
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
