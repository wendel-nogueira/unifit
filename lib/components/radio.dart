import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/constants.dart';

class RadioCustom extends StatefulWidget {
  const RadioCustom({
    Key? key,
    required this.hintText,
    required this.checked,
    required this.onChanged,
  }) : super(key: key);

  final String hintText;
  final bool checked;
  final Function onChanged;

  @override
  State<RadioCustom> createState() => _RadioCustomState();
}

class _RadioCustomState extends State<RadioCustom> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            widget.hintText,
            style: GoogleFonts.roboto(
              color: fontColorWhite,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.left,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: widget.checked
                  ? bgColorBlueLightSecondary
                  : bgColorWhiteNormal,
              minimumSize: const Size(24, 24),
              maximumSize: const Size(24, 24),
              shape: const RoundedRectangleBorder(
                borderRadius: borderRadiusLarger,
              ),
              padding: const EdgeInsets.all(0),
              side: const BorderSide(
                width: 2.0,
                style: BorderStyle.solid,
                color: bgColorWhiteDark,
              ),
            ),
            child: const SizedBox(
              width: 10,
              height: 10,
            ),
            onPressed: () {
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }
}
