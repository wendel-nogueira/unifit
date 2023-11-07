import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/services/get_student_frequency.dart';
import 'package:clean_calendar/clean_calendar.dart';

import '../../components/page.dart';
import '../../constants.dart';
import '../../controllers/account_controller.dart';
import '../../models/user.dart';
import '../../services/get_students.dart';
import '../../utils/birth_date_format.dart';

class StudentFrequencyScreen extends StatefulWidget {
  const StudentFrequencyScreen({super.key});

  @override
  State<StudentFrequencyScreen> createState() => _StudentFrequencyScreen();
}

class _StudentFrequencyScreen extends State<StudentFrequencyScreen> {
  int studentId = -1;
  User? student;
  bool loadingStudent = true;
  bool loadingFrequency = true;
  List<DateTime> selectedDates = [];

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

                    getStudentFrequency(token, studentId).then(
                      (value) => {
                        if (mounted)
                          setState(
                            () {
                              for (var element in value) {
                                selectedDates.add(element.dataHora);
                              }

                              loadingFrequency = false;
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
    var width = MediaQuery.of(context).size.width;

    return MasterPage(
      title: 'frequência',
      showMenu: false,
      child: Column(
        children: [
          Container(
            width: width - 2 * defaultPadding,
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
              boxShadow: [boxShadowDefault],
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
                      const SizedBox(height: 12),
                      Container(
                        margin:
                            const EdgeInsets.only(bottom: defaultPadding / 2),
                        child: const Divider(
                          color: bgColorWhiteDark,
                          height: 1,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      !loadingFrequency
                          ? CleanCalendar(
                              startDateOfCalendar: DateTime(2023, 1, 1),
                              endDateOfCalendar: DateTime(2025, 12, 31),
                              selectedDates: selectedDates,
                              currentDateOfCalendar: DateTime.now().subtract(
                                const Duration(hours: 3),
                              ),
                              selectedDatesProperties: DatesProperties(
                                datesDecoration: DatesDecoration(
                                  datesBackgroundColor: Colors.green,
                                  datesBorderColor: Colors.green,
                                ),
                              ),
                              streakDatesProperties: DatesProperties(
                                datesDecoration: DatesDecoration(
                                  datesBackgroundColor: Colors.green,
                                ),
                              ),
                              headerProperties: HeaderProperties(
                                monthYearDecoration: MonthYearDecoration(
                                  monthYearTextStyle: GoogleFonts.manrope(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: fontColorGray,
                                  ),
                                ),
                                navigatorDecoration: NavigatorDecoration(
                                  navigateLeftButtonIcon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: fontColorGray,
                                    size: 16,
                                  ),
                                  navigateRightButtonIcon: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: fontColorGray,
                                    size: 16,
                                  ),
                                  navigatorResetButtonIcon: const Icon(
                                    Icons.today,
                                    color: fontColorGray,
                                  ),
                                ),
                              ),
                              monthsSymbol: const Months(
                                january: "Jan",
                                february: "Fev",
                                march: "Mar",
                                april: "Abr",
                                may: "Mai",
                                june: "Jun",
                                july: "Jul",
                                august: "Ago",
                                september: "Set",
                                october: "Out",
                                november: "Nov",
                                december: "Dez",
                              ),
                              weekdaysSymbol: const Weekdays(
                                monday: "Seg",
                                tuesday: "Ter",
                                wednesday: "Qua",
                                thursday: "Qui",
                                friday: "Sex",
                                saturday: "Sab",
                                sunday: "Dom",
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
