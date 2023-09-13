import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/button.dart';
import 'package:unifit/components/input.dart';
import 'package:unifit/components/link.dart';
import 'package:unifit/components/radio.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/services/auth.service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  int type = 0;
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> types = <String>[
      'aluno',
      'professor',
      'tec. adm.',
    ];

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
                  'UniFit',
                  style: GoogleFonts.roboto(
                    color: fontColorWhite,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  textWidthBasis: TextWidthBasis.longestLine,
                ),
              ),
              const SizedBox(height: defaultMarginSmall),
              Center(
                child: Text(
                  'acesso institucional',
                  style: GoogleFonts.manrope(
                    color: fontColorWhite,
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 80),
              InputPrimary(
                hintText: 'email',
                type: 'email',
                onChanged: (String value) {
                  email = value;
                },
              ),
              InputPrimary(
                hintText: 'senha',
                type: 'password',
                onChanged: (String value) {
                  password = value;
                },
              ),
              const SizedBox(height: defaultMarginLarge),
              ButtonPrimary(
                hintText: 'entrar',
                onPressed: () {
                  auth(email, password, type);
                },
              ),
              const SizedBox(height: defaultMarginSmall),
              Link(
                  hintText: 'esqueceu a senha?',
                  onPressed: () {
                    Get.toNamed('/recovery-pass-primary');
                  }),
              const SizedBox(height: defaultMarginLarger),
              Row(
                verticalDirection: VerticalDirection.down,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RadioCustom(
                    hintText: types[0],
                    checked: type == 0,
                    onChanged: () {
                      setState(() {
                        type = 0;
                      });
                    },
                  ),
                  const SizedBox(width: defaultMarginSmall),
                  RadioCustom(
                    hintText: types[1],
                    checked: type == 1,
                    onChanged: () {
                      setState(() {
                        type = 1;
                      });
                    },
                  ),
                  const SizedBox(width: defaultMarginSmall),
                  RadioCustom(
                    hintText: types[2],
                    checked: type == 2,
                    onChanged: () {
                      setState(() {
                        type = 2;
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
