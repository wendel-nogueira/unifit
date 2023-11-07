import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/services/add_student_sheet.dart';
import 'package:unifit/services/get_sheets.dart';

import '../../components/page.dart';
import '../../constants.dart';
import '../../controllers/account_controller.dart';
import '../../models/sheet.dart';
import '../../models/user.dart';
import '../../services/get_student_sheets.dart';
import '../../services/get_students.dart';
import '../../utils/birth_date_format.dart';

class StudentSheetScreen extends StatefulWidget {
  const StudentSheetScreen({super.key});

  @override
  State<StudentSheetScreen> createState() => _StudentSheetScreen();
}

class _StudentSheetScreen extends State<StudentSheetScreen> {
  int studentId = -1;
  User? student;
  bool loadingStudent = true;
  bool loadingSheets = true;
  bool loadingAllSheets = true;
  List<Sheet> allSheets = [];
  List<Sheet> sheets = [];

  Sheet? selectedSheet;
  var comments = '';
  bool addButtonEnabled = true;

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

                    refresh();
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

  void refresh() {
    loadingSheets = true;

    String token = Get.find<AccountController>().token!;

    getStudentSheets(token, studentId).then(
      (value) => {
        if (mounted)
          setState(
            () {
              sheets = value;
              loadingSheets = false;

              getSheets(token).then(
                (value) => {
                  if (mounted)
                    setState(
                      () {
                        allSheets = value;

                        List<Sheet> sheetsToRemove = [];

                        for (var sheet in allSheets) {
                          for (var studentSheet in sheets) {
                            if (sheet.idficha == studentSheet.idficha) {
                              sheetsToRemove.add(sheet);
                            }
                          }
                        }

                        allSheets.removeWhere(
                          (element) => sheetsToRemove.contains(element),
                        );

                        if (allSheets.isEmpty) {
                          addButtonEnabled = false;
                        }

                        loadingAllSheets = false;
                      },
                    )
                },
              );
            },
          )
      },
    );
  }

  void addSheet() {
    var token = Get.find<AccountController>().token!;

    addStudentSheet(token, selectedSheet!, comments, studentId).then(
      (value) => {
        if (value == 200)
          {
            refresh(),
          },
        selectedSheet = null,
        comments = '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double cardWidth = width - (2 * defaultPadding);

    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    return MasterPage(
      title: 'fichas do aluno',
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
                      !loadingAllSheets
                          ? addButtonEnabled
                              ? TextButton(
                                  onPressed: () => {
                                    Get.dialog(
                                      Center(
                                        child: Container(
                                          width: dialogSize,
                                          height: 344,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(
                                              defaultPadding),
                                          decoration: const BoxDecoration(
                                            color: bgColorWhiteNormal,
                                            borderRadius: borderRadiusSmall,
                                            boxShadow: [boxShadowDefault],
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  'adicionar ficha',
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: fontColorGray,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: defaultMarginSmall),
                                              Material(
                                                child: DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    isDense: true,
                                                    hintStyle:
                                                        GoogleFonts.manrope(
                                                      color: fontColorGray,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        bgColorWhiteLight,
                                                    hintText:
                                                        'selecione uma ficha',
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          borderRadiusSmall,
                                                      borderSide: BorderSide(
                                                        width: 0,
                                                        style: BorderStyle.none,
                                                      ),
                                                    ),
                                                    contentPadding: const EdgeInsets
                                                            .symmetric(
                                                        vertical:
                                                            defaultPaddingFieldsVertical,
                                                        horizontal:
                                                            defaultPaddingFieldsHorizontal),
                                                  ),
                                                  items: [
                                                    for (var sheet in allSheets)
                                                      DropdownMenuItem(
                                                        value: sheet,
                                                        child: Text(sheet.nome),
                                                      ),
                                                  ],
                                                  value: selectedSheet,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedSheet = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: defaultMarginLarge),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  'observações',
                                                  style: GoogleFonts.roboto(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: fontColorGray,
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: defaultMarginSmall),
                                              Material(
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    isDense: true,
                                                    hintStyle:
                                                        GoogleFonts.manrope(
                                                      color: fontColorGray,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        bgColorWhiteLight,
                                                    hintText: 'observações',
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          borderRadiusSmall,
                                                      borderSide: BorderSide(
                                                          color:
                                                              bgColorWhiteDark),
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          borderRadiusSmall,
                                                      borderSide: BorderSide(
                                                          color:
                                                              bgColorBlueNormal),
                                                    ),
                                                    contentPadding: const EdgeInsets
                                                            .symmetric(
                                                        vertical:
                                                            defaultPaddingFieldsVertical,
                                                        horizontal:
                                                            defaultPaddingFieldsHorizontal),
                                                  ),
                                                  maxLines: 3,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      comments = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              TextButton(
                                                onPressed: () => {
                                                  addSheet(),
                                                  Get.back(),
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          statusColorSuccess),
                                                ),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    'adicionar',
                                                    style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      color: fontColorWhite,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => {
                                                  Get.back(),
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          statusColorError),
                                                ),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Text(
                                                    'fechar',
                                                    style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      color: fontColorWhite,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            statusColorInfo),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'adicionar ficha',
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: fontColorWhite,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : const SizedBox()
                          : const Center(
                              child: CircularProgressIndicator(),
                            ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          !loadingSheets
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: addButtonEnabled
                          ? height - 300
                          : height - 250, // fixed height
                      child: ListView.builder(
                        itemCount: sheets.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              InkWell(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPaddingCardHorizontal,
                                      vertical: defaultPaddingCardVertical),
                                  decoration: const BoxDecoration(
                                    color: bgColorWhiteNormal,
                                    borderRadius: borderRadiusMedium,
                                    boxShadow: [boxShadowDefault],
                                  ),
                                  width: cardWidth,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            sheets[index].nome,
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: fontColorBlue,
                                            ),
                                          ),
                                          // icon dots
                                          const Icon(
                                            Icons.more_vert,
                                            color: fontColorBlue,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'tipo: ${sheets[index].tipo}',
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: fontColorGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Get.toNamed(
                                      '/sheets-details/${sheets[index].idficha}');
                                },
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
