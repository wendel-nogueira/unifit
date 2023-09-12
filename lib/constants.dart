import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const bgColorWhiteLight = Color.fromRGBO(244, 245, 246, 1);
const bgColorWhiteNormal = Color.fromRGBO(254, 252, 254, 1);
const bgColorWhiteDark = Color.fromRGBO(234, 232, 234, 1);
const bgColorBlueLight = Color.fromRGBO(215, 235, 253, 1);
const bgColorBlueLightSecondary = Color.fromRGBO(94, 155, 253, 1);
const bgColorBlueNormal = Color.fromRGBO(18, 61, 214, 1);
const bgColorBlueDark = Color.fromRGBO(18, 22, 70, 1);
const bgColorGray = Color.fromRGBO(46, 49, 58, 1);

const fontColorBlue = Color.fromRGBO(27, 67, 208, 1);
const fontColorWhite = Color.fromRGBO(250, 250, 250, 1);
const fontColorGray = Color.fromRGBO(84, 83, 84, 1);
const fontColorBlack = Color.fromRGBO(16, 16, 16, 1);

const statusColorSuccess = Color.fromRGBO(46, 233, 65, 1);
const statusColorSuccessDark = Color.fromRGBO(25, 179, 0, 1);
const statusColorWarning = Color.fromRGBO(248, 175, 20, 20);
const statusColorWarningDark = Color.fromRGBO(179, 127, 0, 1);
const statusColorError = Color.fromRGBO(233, 46, 48, 1);
const statusColorErrorDark = Color.fromRGBO(179, 0, 0, 1);
const statusColorInfo = Color.fromRGBO(71, 139, 248, 1);
const statusColorInfoDark = Color.fromRGBO(15, 76, 129, 1);

const double defaultPadding = 24.0;
const double defaultPaddingFieldsVertical = 8.0;
const double defaultPaddingFieldsHorizontal = 12.0;

const double defaultMarginSmall = 6.0;
const double defaultMarginMedium = 8.0;
const double defaultMarginLarge = 12.0;
const double defaultMarginLarger = 24.0;

const defaultRadiusSmall = 5.0;
const defaultRadiusMedium = 8.0;
const defaultRadiusLarger = 20.0;

const borderRadiusSmall = BorderRadius.all(Radius.circular(defaultRadiusSmall));
const borderRadiusMedium =
    BorderRadius.all(Radius.circular(defaultRadiusMedium));
const borderRadiusLarger =
    BorderRadius.all(Radius.circular(defaultRadiusLarger));

// título - Roboto / Bold
// subtítulo - Roboto / SemiBold
// parágrafo - Manrope / Regular
// descrição - Manrope / Light

final titleFont = GoogleFonts.roboto(fontWeight: FontWeight.bold);
final subtitleFont = GoogleFonts.roboto(fontWeight: FontWeight.w500);
final paragraphFont = GoogleFonts.manrope(fontWeight: FontWeight.normal);
final descriptionFont = GoogleFonts.manrope(fontWeight: FontWeight.w300);
