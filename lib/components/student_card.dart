import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/constants.dart';

import '../utils/birth_date_format.dart';

class StudentCard extends StatefulWidget {
  const StudentCard(
      {super.key,
      required this.registration,
      required this.name,
      required this.course,
      required this.birthDate,
      required this.onTap});

  final String registration;
  final String name;
  final String course;
  final String birthDate;
  final Function onTap;

  @override
  State<StudentCard> createState() => _StudentCard();
}

class _StudentCard extends State<StudentCard> {
  @override
  Widget build(BuildContext context) {
    String birthDate = verifyAbirthDateFormat(widget.birthDate);
    double width = double.parse(MediaQuery.of(context).size.width.toString());
    double cardWidth = width - (2 * defaultPadding);

    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPaddingCardHorizontal,
            vertical: defaultPaddingCardVertical),
        decoration: const BoxDecoration(
          color: bgColorWhiteNormal,
          borderRadius: borderRadiusMedium,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: cardWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.registration,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: fontColorBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'nome: ${widget.name}',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: fontColorGray,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'curso: ${widget.course}',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: fontColorGray,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'nascimento: $birthDate',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: fontColorGray,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
