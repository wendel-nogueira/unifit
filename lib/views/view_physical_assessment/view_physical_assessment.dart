import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/models/assessment.dart';

import '../../components/page.dart';
import '../../constants.dart';

class ViewPhysicalAssessmentScreen extends StatefulWidget {
  const ViewPhysicalAssessmentScreen({super.key});

  @override
  State<ViewPhysicalAssessmentScreen> createState() =>
      _ViewPhysicalAssessmentScreen();
}

class _ViewPhysicalAssessmentScreen
    extends State<ViewPhysicalAssessmentScreen> {
  Assessment assessment = Assessment();
  bool loadingAssessment = true;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(
        () {
          var arguments = Get.arguments;

          if (arguments != null) {
            assessment = arguments as Assessment;
          }

          loadingAssessment = false;
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var fields = assessment.getFormFields();

    return MasterPage(
      title: 'avaliação #${assessment.id}',
      showMenu: false,
      child: SizedBox(
        width: width - 2 * defaultPadding,
        height: height - 80, // fixed height
        child: ListView.builder(
          itemCount: fields.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: defaultMarginLarge),
                Text(
                  fields[index]['label'],
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: fontColorGray,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: defaultMarginSmall),
                TextFormField(
                  keyboardType: fields[index]['type'] == 'number'
                      ? TextInputType.number
                      : TextInputType.text,
                  initialValue: fields[index]['value'].toString(),
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
                    hintText: fields[index]['label'],
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: borderRadiusSmall,
                      borderSide: BorderSide(color: bgColorWhiteDark),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: borderRadiusSmall,
                      borderSide: BorderSide(color: bgColorWhiteDark),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: defaultPaddingFieldsVertical,
                        horizontal: defaultPaddingFieldsHorizontal),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: defaultMarginSmall),
                if (index == fields.length - 1)
                  const SizedBox(height: defaultMarginLarger),
              ],
            );
          },
        ),
      ),
    );
  }
}
