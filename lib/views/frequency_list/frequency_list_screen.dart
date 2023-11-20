import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/page.dart';
import 'package:unifit/components/student_card.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/user.dart';
import 'package:unifit/services/get_students.dart';
import 'package:unifit/services/get_students_frequency.dart';
import 'package:unifit/utils/alert.dart';

import '../../models/frequency.dart';

class FrequencyListScreen extends StatefulWidget {
  const FrequencyListScreen({super.key});

  @override
  State<FrequencyListScreen> createState() => _FrequencyListScreen();
}

class _FrequencyListScreen extends State<FrequencyListScreen> {
  bool searched = false;
  List<User> students = [];
  List<User> allStudents = [];
  DateTime? initDate;
  DateTime? endDate;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      String token = Get.find<AccountController>().token!;

      getStudents(token).then(
        (value) => {
          if (mounted)
            setState(
              () {
                allStudents = value;
              },
            )
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void search() async {
    if (initDate == null || endDate == null) {
      showAlert('Atenção', 'Selecione as datas para realizar a busca', 'error');
      return;
    }

    if (initDate!.isAfter(endDate!)) {
      showAlert(
          'Atenção', 'A data inicial não pode ser maior que a final', 'error');
      return;
    }

    searched = true;
    students = [];

    Dialog dialog = const Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) => dialog,
    );

    List<DateTime> dates = [];

    for (var i = initDate!.millisecondsSinceEpoch;
        i <= endDate!.millisecondsSinceEpoch;
        i += 86400000) {
      dates.add(DateTime.fromMillisecondsSinceEpoch(i));
    }

    List<User> users = [];

    for (var date in dates) {
      String token = Get.find<AccountController>().token!;

      List<Frequency> frequency = await getStudentsFrequency(token, date);

      for (var item in frequency) {
        User? student = allStudents.firstWhere(
            (element) => element.idAluno == item.alunoParticipaAlunoIdaluno);

        if (!users.contains(student)) {
          users.add(student);
        }
      }
    }

    setState(() {
      students = users;
    });

    if (context.mounted) Navigator.pop(context);
  }

  String formatDateTime(DateTime dateTime) {
    String day =
        dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day.toString();
    String month =
        dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month.toString();
    String year = dateTime.year.toString();

    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    return MasterPage(
      title: 'frequência',
      showBackButton: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width - 2 * defaultPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => {
                    showDatePicker(
                      context: context,
                      currentDate: DateTime.now().subtract(
                        const Duration(hours: 3),
                      ),
                      initialDate: initDate ??
                          DateTime.now().subtract(
                            const Duration(hours: 3),
                          ),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                      confirmText: 'Confirmar',
                      cancelText: 'Cancelar',
                      helpText: 'Selecione a data inicial',
                    ).then((value) => {
                          if (value != null)
                            {
                              setState(() {
                                initDate = value;
                              })
                            }
                        })
                  },
                  child: Container(
                    width: 115,
                    height: 34,
                    alignment: Alignment.center,
                    transformAlignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: bgColorWhiteNormal,
                      borderRadius: borderRadiusSmall,
                      boxShadow: [boxShadowDefault],
                    ),
                    child: Text(
                      initDate != null
                          ? formatDateTime(initDate!)
                          : '00/00/0000',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: fontColorGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'a',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: fontColorGray,
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  onTap: () => {
                    showDatePicker(
                      context: context,
                      currentDate: DateTime.now().subtract(
                        const Duration(hours: 3),
                      ),
                      initialDate: endDate ??
                          DateTime.now().subtract(
                            const Duration(hours: 3),
                          ),
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2100),
                      confirmText: 'Confirmar',
                      cancelText: 'Cancelar',
                      helpText: 'Selecione a data final',
                    ).then((value) => {
                          if (value != null)
                            {
                              setState(() {
                                endDate = value;
                              })
                            }
                        })
                  },
                  child: Container(
                    width: 115,
                    height: 34,
                    alignment: Alignment.center,
                    transformAlignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: bgColorWhiteNormal,
                      borderRadius: borderRadiusSmall,
                      boxShadow: [boxShadowDefault],
                    ),
                    child: Text(
                      endDate != null ? formatDateTime(endDate!) : '00/00/0000',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: fontColorGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => {
                    search(),
                  },
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: bgColorBlueNormal,
                      borderRadius: borderRadiusSmall,
                      boxShadow: [boxShadowDefault],
                    ),
                    child: const Icon(
                      Icons.search,
                      color: fontColorWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          searched && students.isNotEmpty
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: height - 206, // fixed height
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              StudentCard(
                                registration: students[index].matricula,
                                name: students[index].nome,
                                course: students[index].curso,
                                birthDate:
                                    students[index].nascimento.toString(),
                                onTap: () => {},
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                )
              : searched && students.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      height: height - 206,
                      child: Text(
                        'Nenhum aluno encontrado!',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: fontColorGray,
                        ),
                      ),
                    )
                  : Container(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
