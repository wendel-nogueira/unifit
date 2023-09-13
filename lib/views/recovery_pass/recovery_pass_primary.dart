import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/button.dart';
import 'package:unifit/components/input.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/services/send_code.service.dart';
import 'package:unifit/utils/alert.dart';

class RecoveryPassPrimaryPage extends StatefulWidget {
  const RecoveryPassPrimaryPage({super.key});

  @override
  State<RecoveryPassPrimaryPage> createState() => _RecoveryPassPrimaryPage();
}

class _RecoveryPassPrimaryPage extends State<RecoveryPassPrimaryPage> {
  String email = '';
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
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
          child: Column(
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
                  'informe o email utilizado durante o seu cadastro no sistema!',
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
                hintText: 'email',
                type: 'email',
                onChanged: (String value) {
                  email = value;
                },
              ),
              const SizedBox(height: defaultMarginLarge),
              ButtonPrimary(
                  hintText: disabled
                      ? 'enviar novamente em 60 segundos'
                      : 'enviar código',
                  disabled: disabled,
                  onPressed: () {
                    if (email.isEmpty) {
                      showAlert('campos inválidos', 'preencha todos os campos!',
                          'error');
                      return;
                    }

                    if (!GetUtils.isEmail(email)) {
                      showAlert(
                          'email inválido',
                          'o email informado não é válido, por favor, tente novamente!',
                          'error');
                      return;
                    }

                    sendCode(email);
                    setState(() {
                      disabled = true;
                    });

                    Future.delayed(const Duration(seconds: 60), () {
                      setState(() {
                        disabled = false;
                      });
                    });
                  }),
              ButtonPrimary(
                  hintText: 'já recebi meu código',
                  onPressed: () {
                    Get.toNamed('/recovery-pass-secondary');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
