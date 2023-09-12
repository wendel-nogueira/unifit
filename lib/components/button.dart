import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/constants.dart';

class ButtonPrimary extends StatefulWidget {
  const ButtonPrimary(
      {super.key,
      required this.hintText,
      required this.onPressed,
      this.disabled = false});

  final String hintText;
  final Function onPressed;
  final bool disabled;

  @override
  State<ButtonPrimary> createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.disabled
            ? null
            : () {
                widget.onPressed();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColorWhiteNormal,
          shape: const RoundedRectangleBorder(
            borderRadius: borderRadiusSmall,
          ),
          padding: const EdgeInsets.symmetric(
              vertical: defaultPaddingFieldsVertical,
              horizontal: defaultPaddingFieldsHorizontal),
          shadowColor: Colors.transparent,
          disabledBackgroundColor: bgColorBlueLightSecondary,
        ),
        child: Text(
          widget.hintText,
          style: GoogleFonts.roboto(
            color: widget.disabled ? fontColorWhite : fontColorGray,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
