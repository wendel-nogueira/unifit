import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/button.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _text = const <int, String>{
    0: 'meus planos',
    1: 'alunos cadastrados',
  };

  @override
  Widget build(BuildContext context) {
    AccountController accountController = Get.find<AccountController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: bgColorWhiteLight,
        ),
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  _text[accountController.type]!,
                  style: GoogleFonts.roboto(
                    color: fontColorBlue,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ButtonPrimary(
                  hintText: 'sair',
                  onPressed: () => accountController.logout()),
            ],
          ),
        ),
      ),
    );
  }
}
