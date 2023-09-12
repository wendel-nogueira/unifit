import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/button.dart';
import 'package:unifit/components/input.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/services/verify_code.service.dart';

class RecoveryPassSecondaryPage extends StatefulWidget {
  const RecoveryPassSecondaryPage({super.key});

  @override
  State<RecoveryPassSecondaryPage> createState() =>
      _RecoveryPassSecondaryPage();
}

class _RecoveryPassSecondaryPage extends State<RecoveryPassSecondaryPage> {
  @override
  Widget build(BuildContext context) {
    String code = '';

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
                  'informe o código recebido no seu email!',
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
                hintText: 'código',
                type: 'number',
                onChanged: (String value) {
                  code = value;
                },
              ),
              const SizedBox(height: defaultMarginLarge),
              ButtonPrimary(
                  hintText: 'verificar código',
                  onPressed: () {
                    verifyCode(code);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
