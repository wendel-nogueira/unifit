import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/page.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/anamnesis.dart';
import 'package:unifit/models/user.dart';
import '../../services/get_anamnesis.dart';
import '../../services/get_students.dart';
import '../../utils/birth_date_format.dart';

class ViewAnamnesisScreen extends StatefulWidget {
  const ViewAnamnesisScreen({super.key});

  @override
  State<ViewAnamnesisScreen> createState() => _ViewAnamnesisScreen();
}

class _ViewAnamnesisScreen extends State<ViewAnamnesisScreen> {
  int studentId = -1;
  User? student;
  Anamnesis anamnesis = Anamnesis();
  bool loadingStudent = true;
  bool loadingAnamnesis = true;

  var accountController = Get.find<AccountController>();
  bool loading = false;

  bool newAnamnesis = false;

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

                    getAnamnesis(token, studentId).then(
                      (value) => {
                        if (mounted)
                          setState(
                            () {
                              anamnesis = value;
                              loadingAnamnesis = false;
                            },
                          ),
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

  showInfo() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var fields = anamnesis.getFormFields();
    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width,
            height: height - 2 * defaultPadding,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              top: defaultPadding,
              bottom: defaultPadding,
              left: defaultPadding,
              right: defaultPadding,
            ),
            decoration: const BoxDecoration(
              color: bgColorWhiteLight,
              borderRadius: borderRadiusSmall,
              boxShadow: [boxShadowDefault],
            ),
            child: Column(
              children: [
                !loadingAnamnesis
                    ? Column(
                        children: <Widget>[
                          SizedBox(
                            height: height -
                                2 * defaultPadding -
                                112, // fixed height
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
                                    fields[index]['type'] != 'select'
                                        ? TextFormField(
                                            initialValue:
                                                fields[index]['value'] ?? '',
                                            keyboardType: TextInputType.text,
                                            style: GoogleFonts.manrope(
                                              color: fontColorGray,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            readOnly: !newAnamnesis,
                                            decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              isDense: true,
                                              hintStyle: GoogleFonts.manrope(
                                                color: fontColorGray,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              filled: true,
                                              fillColor: bgColorWhiteLight,
                                              hintText: fields[index]['label'],
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: borderRadiusSmall,
                                                borderSide: BorderSide(
                                                    color: bgColorWhiteDark),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: borderRadiusSmall,
                                                borderSide: BorderSide(
                                                    color: bgColorBlueNormal),
                                              ),
                                              contentPadding: const EdgeInsets
                                                      .symmetric(
                                                  vertical:
                                                      defaultPaddingFieldsVertical,
                                                  horizontal:
                                                      defaultPaddingFieldsHorizontal),
                                            ),
                                            onChanged: newAnamnesis
                                                ? (value) {
                                                    setState(() {
                                                      anamnesis.updateValue(
                                                          fields[index]
                                                              ['atribute'],
                                                          value);
                                                    });
                                                  }
                                                : null,
                                          )
                                        : DropdownButtonFormField(
                                            decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              isDense: true,
                                              hintStyle: GoogleFonts.manrope(
                                                color: fontColorGray,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              filled: true,
                                              fillColor: bgColorWhiteLight,
                                              hintText: fields[index]['label'],
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: borderRadiusSmall,
                                                borderSide: BorderSide(
                                                    color: bgColorWhiteDark),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: borderRadiusSmall,
                                                borderSide: BorderSide(
                                                    color: bgColorBlueNormal),
                                              ),
                                              contentPadding: const EdgeInsets
                                                      .symmetric(
                                                  vertical:
                                                      defaultPaddingFieldsVertical,
                                                  horizontal:
                                                      defaultPaddingFieldsHorizontal),
                                            ),
                                            items: [
                                              for (var option in fields[index]
                                                  ['options'] as List<String>)
                                                DropdownMenuItem(
                                                  value: option,
                                                  child: Text(option),
                                                ),
                                            ],
                                            value: fields[index]['value'] !=
                                                        null &&
                                                    fields[index]['value'] != ''
                                                ? fields[index]['value']
                                                : null,
                                            onChanged: null),
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
                const SizedBox(height: defaultMarginLarge),
                TextButton(
                  onPressed: () => {
                    Get.back(),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(statusColorError),
                  ),
                  child: SizedBox(
                    width: width - 2 * defaultPadding,
                    child: Text(
                      'fechar',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
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
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return MasterPage(
      title: 'anamnese',
      showMenu: false,
      backButtonFunction: () => Get.offAndToNamed('/students-list'),
      child: Column(
        children: [
          Container(
            width: width - 2 * defaultPadding,
            height: height - 500,
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        // divider
                        const SizedBox(height: 12),
                        !newAnamnesis
                            ? TextButton(
                                onPressed: () => {
                                  Get.toNamed(
                                    '/new-user-anamnesis/${student!.idAluno}',
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
                                    'nova anamnese',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: fontColorWhite,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ])
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          const SizedBox(height: 12),
          !loadingAnamnesis
              ? SizedBox(
                  width: width - 2 * defaultPadding,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: bgColorWhiteNormal,
                      borderRadius: BorderRadius.all(
                        Radius.circular(defaultRadiusSmall),
                      ),
                      boxShadow: [boxShadowDefault],
                    ),
                    margin: const EdgeInsets.only(bottom: defaultPadding / 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPaddingCardHorizontal,
                              vertical: defaultPaddingCardVertical),
                          child: Text(
                            'anamnese',
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
                            showInfo(),
                          },
                        ),
                      ],
                    ),
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
