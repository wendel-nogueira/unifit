import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/constants.dart';

class InputPrimary extends StatefulWidget {
  const InputPrimary({
    Key? key,
    required this.hintText,
    required this.type,
    required this.onChanged,
  }) : super(key: key);

  final String hintText;
  final String type;
  final Function onChanged;

  @override
  State<InputPrimary> createState() => _InputPrimaryState();
}

class _InputPrimaryState extends State<InputPrimary> {
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;

      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      }

      textFieldFocusNode.canRequestFocus = false;
    });
  }

  final Map<String, TextInputType> types = {
    'text': TextInputType.text,
    'number': TextInputType.number,
    'email': TextInputType.emailAddress,
    'phone': TextInputType.phone,
    'password': TextInputType.visiblePassword,
    'multiline': TextInputType.multiline,
    'date': TextInputType.datetime,
    'checkbox': TextInputType.text,
  };

  @override
  void initState() {
    super.initState();

    textFieldFocusNode.addListener(() {
      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      }

      textFieldFocusNode.canRequestFocus = false;
    });

    if (widget.type == 'password') {
      _obscured = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              widget.hintText,
              style: GoogleFonts.roboto(
                color: fontColorWhite,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: defaultMarginMedium),
          widget.type != 'checkbox'
              ? TextField(
                  keyboardType: types[widget.type],
                  obscureText: _obscured,
                  style: GoogleFonts.manrope(
                    color: fontColorGray,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    hintStyle: GoogleFonts.manrope(
                      color: fontColorGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    filled: true,
                    fillColor: bgColorWhiteNormal,
                    hintText: widget.hintText,
                    border: const OutlineInputBorder(
                      borderRadius: borderRadiusSmall,
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: defaultPaddingFieldsVertical,
                        horizontal: defaultPaddingFieldsHorizontal),
                    suffixIcon: widget.type == 'password'
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                                0, 0, defaultPaddingFieldsHorizontal, 0),
                            child: GestureDetector(
                              onTap: _toggleObscured,
                              child: Icon(
                                _obscured
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: 16,
                                color: bgColorBlueLightSecondary,
                              ),
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(
                      maxHeight: 24,
                      maxWidth: 24,
                    ),
                  ),
                  onChanged: (value) {
                    widget.onChanged(value);
                  },
                )
              : Checkbox(
                  value: widget.type == 'checkbox' ? true : false,
                  onChanged: (value) {
                    widget.onChanged(value);
                  },
                ),
          const SizedBox(height: defaultMarginMedium),
        ],
      ),
    );
  }
}
