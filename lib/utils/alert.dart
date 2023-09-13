import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/constants.dart';

final Map<String, Color> statusColors = {
  'error': statusColorError,
  'success': statusColorSuccess,
  'warning': statusColorWarning,
  'info': statusColorInfo,
};

showAlert(String title, String message, String status) => Get.snackbar(
      title,
      message,
      borderRadius: defaultRadiusSmall,
      backgroundColor: bgColorWhiteNormal,
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 500),
      titleText: Text(
        title,
        style: GoogleFonts.roboto(
          color: statusColors[status]!,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      messageText: Text(
        message,
        style: GoogleFonts.manrope(
          color: fontColorGray,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    );

showLoading() => Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: fontColorWhite,
          backgroundColor: bgColorBlueLightSecondary,
        ),
      ),
      barrierDismissible: true,
      name: 'loading',
      barrierColor: Colors.black.withOpacity(0.5),
      arguments: 'loading',
    );

hideLoading() => Get.back(closeOverlays: true);
