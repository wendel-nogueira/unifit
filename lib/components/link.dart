import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/constants.dart';

class Link extends StatelessWidget {
  const Link({super.key, required this.hintText, required this.onPressed});

  final String hintText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Text(
          hintText,
          style: GoogleFonts.roboto(
            color: fontColorWhite,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }
}
