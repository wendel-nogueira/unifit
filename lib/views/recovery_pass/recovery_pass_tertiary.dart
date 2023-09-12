import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/button.dart';
import 'package:unifit/components/input.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/services/change_password.dart';

class RecoveryPassTertiaryPage extends StatefulWidget {
  const RecoveryPassTertiaryPage({super.key});

  @override
  State<RecoveryPassTertiaryPage> createState() => _RecoveryPassTertiaryPage();
}

class _RecoveryPassTertiaryPage extends State<RecoveryPassTertiaryPage> {
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
                onPressed: () {
                  changePassword(newPassword, repeatPassword);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
