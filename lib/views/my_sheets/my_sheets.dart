import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/page.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/sheet.dart';
import 'package:unifit/services/get_sheets.dart';
import 'package:unifit/services/get_student_sheets.dart';

class MySheetsScreen extends StatefulWidget {
  const MySheetsScreen({super.key});

  @override
  State<MySheetsScreen> createState() => _MySheetsScreen();
}

class _MySheetsScreen extends State<MySheetsScreen> {
  List<Sheet> sheets = [];
  List<Sheet> sheetsFiltered = [];
  String search = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      var accountController = Get.find<AccountController>();

      String token = accountController.token!;
      int studentId = accountController.user!.idAluno;

      getStudentSheets(token, studentId).then(
        (value) => {
          if (mounted)
            setState(
              () {
                sheets = value;
                sheetsFiltered = value;

                loading = false;
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
      title: 'minhas fichas',
      showBackButton: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: width - 2 * defaultPadding,
              height: 34,
              child: Container(
                decoration: const BoxDecoration(
                  color: bgColorWhiteNormal,
                  borderRadius: borderRadiusSmall,
                  boxShadow: [boxShadowDefault],
                ),
                child: TextField(
                  onChanged: (value) => {
                    setState(
                      () {
                        search = value;

                        if (search.isEmpty) {
                          sheetsFiltered = sheets;
                        } else {
                          sheetsFiltered = sheets
                              .where((element) =>
                                  element.nome
                                      .toLowerCase()
                                      .contains(search.toLowerCase()) ||
                                  element.tipo
                                      .toLowerCase()
                                      .contains(search.toLowerCase()))
                              .toList();
                        }
                      },
                    )
                  },
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
                    hintText: 'buscar',
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
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(
                          defaultPaddingFieldsHorizontal, 0, 0, 0),
                      child: GestureDetector(
                          onTap: () => {
                                setState(
                                  () {
                                    if (search.isEmpty) {
                                      sheetsFiltered = sheets;
                                    } else {
                                      sheetsFiltered = sheets
                                          .where((element) =>
                                              element.nome
                                                  .toLowerCase()
                                                  .contains(
                                                      search.toLowerCase()) ||
                                              element.tipo
                                                  .toLowerCase()
                                                  .contains(
                                                      search.toLowerCase()))
                                          .toList();
                                    }
                                  },
                                )
                              },
                          child: InkWell(
                            child: Container(
                              width: 34,
                              height: 34,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: bgColorBlueNormal,
                                borderRadius: borderRadiusSmall,
                                boxShadow: [boxShadowDefault],
                              ),
                              child: const Icon(
                                Icons.search,
                                color: fontColorWhite,
                                size: 24,
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          !loading
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: height - 206, // fixed height
                      child: ListView.builder(
                        itemCount: sheetsFiltered.length,
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
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        'tipo: ${sheetsFiltered[index].tipo}',
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
                                      '/sheets-details/${sheetsFiltered[index].idficha}');
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
              : SizedBox(
                  height: height - 206,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
