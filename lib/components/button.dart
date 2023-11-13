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

class ButtonSecondary extends StatefulWidget {
  const ButtonSecondary(
      {super.key,
      required this.hintText,
      required this.onPressed,
      this.type = ButtonType.info});

  final String hintText;
  final Function onPressed;
  final ButtonType type;

  @override
  State<ButtonSecondary> createState() => _ButtonSecondary();
}

enum ButtonType {
  success,
  warning,
  danger,
  info,
}

class _ButtonSecondary extends State<ButtonSecondary> {
  Color typeToColor(ButtonType type) {
    switch (type) {
      case ButtonType.success:
        return statusColorSuccess;
      case ButtonType.warning:
        return statusColorWarning;
      case ButtonType.danger:
        return statusColorError;
      case ButtonType.info:
        return statusColorInfo;
      default:
        return statusColorInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => {
        widget.onPressed(),
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(typeToColor(widget.type)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          widget.hintText,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: fontColorWhite,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
