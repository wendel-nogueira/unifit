import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/button.dart';
import 'package:unifit/components/menu.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final _text = const <int, String>{
    0: 'minhas fichas',
    1: 'alunos cadastrados',
  };

  @override // onInit
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AccountController accountController = Get.find<AccountController>();

    int type = accountController.type!;

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: bgColorWhiteLight,
        ),
        padding: const EdgeInsets.all(defaultPadding),
        alignment: Alignment.center,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  _text[type]!,
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
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenSize.height * 0.1,
        alignment: Alignment.bottomCenter,
        child: Menu(accountType: type),
      ),
    );
  }
}
