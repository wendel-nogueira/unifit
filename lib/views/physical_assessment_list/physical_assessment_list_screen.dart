import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/models/assessment.dart';
import 'package:unifit/services/get_Assessment.dart';

import '../../components/page.dart';
import '../../constants.dart';
import '../../controllers/account_controller.dart';
import '../../models/user.dart';
import '../../services/get_students.dart';
import '../../utils/birth_date_format.dart';

class PhysicalAssessmentList extends StatefulWidget {
  const PhysicalAssessmentList({super.key});

  @override
  State<PhysicalAssessmentList> createState() => _PhysicalAssessmentList();
}

class _PhysicalAssessmentList extends State<PhysicalAssessmentList> {
  int studentId = -1;
  User? student;
  bool loadingStudent = true;
  bool loadingAssessments = true;
  List<Assessment> assessments = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        var queryParams = Get.parameters;

        if (queryParams['id'] != null) {
          studentId = int.parse(queryParams['id']!);
        }

        String token = Get.find<AccountController>().token!;

        getStudents(token).then(
          (value) => {
            if (mounted)
              setState(
                () {
                  if (studentId != -1) {
                    student = value.firstWhere(
                      (element) => element.idAluno == studentId,
                    );

                    loadingStudent = false;

                    getAssessment(token, studentId).then(
                      (value) => {
                        if (mounted)
                          setState(
                            () {
                              assessments = value;
                              loadingAssessments = false;
                            },
                          )
                      },
                    );
                  }
                },
              )
          },
        );
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return MasterPage(
      title: 'avaliações',
      showMenu: false,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: defaultPadding),
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPaddingCardHorizontal,
              vertical: defaultPaddingCardVertical,
            ),
            decoration: const BoxDecoration(
              color: bgColorWhiteNormal,
              borderRadius: BorderRadius.all(
                Radius.circular(defaultRadiusMedium),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: !loadingStudent
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'nome: ${student != null ? student!.nome : 'erro'}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: fontColorGray,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'curso: ${student != null ? student!.curso : ''}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: fontColorGray,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'email: ${student != null ? student!.email : ''}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: fontColorGray,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'nascimento: ${student != null ? verifyAbirthDateFormat(student!.nascimento.toString()) : ''}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: fontColorGray,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: defaultPadding / 2),
            child: const Divider(
              color: bgColorWhiteDark,
              height: 1,
              thickness: 1,
            ),
          ),
          TextButton(
            onPressed: () => {
              Get.toNamed('/new-physical-assessments/$studentId'),
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(statusColorSuccess),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'nova avaliação',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: fontColorWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          !loadingAssessments
              ? SizedBox(
                  height: height - 310, // fixed height
                  child: ListView.builder(
                    itemCount: assessments.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: bgColorWhiteNormal,
                              borderRadius: BorderRadius.all(
                                Radius.circular(defaultRadiusSmall),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.only(
                                bottom: defaultPadding / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPaddingCardHorizontal,
                                      vertical: defaultPaddingCardVertical),
                                  child: Text(
                                    'avaliação #${assessments[index].id}',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPaddingCardVertical,
                                        vertical: defaultPaddingCardVertical),
                                    decoration: const BoxDecoration(
                                      color: statusColorWarning,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(defaultRadiusSmall),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: fontColorWhite,
                                      size: 18,
                                    ),
                                  ),
                                  onTap: () => {
                                    // set body
                                    Get.toNamed('/view-physical-assessments',
                                        arguments: assessments[index]),
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
