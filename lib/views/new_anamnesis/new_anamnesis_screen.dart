import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/page.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/anamnesis.dart';
import 'package:unifit/models/user.dart';
import 'package:unifit/utils/alert.dart';

import '../../services/create_anamnesis.dart';
import '../../services/get_students.dart';

class NewAnamnesisScreen extends StatefulWidget {
  const NewAnamnesisScreen({super.key});

  @override
  State<NewAnamnesisScreen> createState() => _NewAnamnesisScreen();
}

class _NewAnamnesisScreen extends State<NewAnamnesisScreen> {
  int studentId = -1;
  User? student;
  Anamnesis anamnesis = Anamnesis();
  bool loadingStudent = true;

  var accountController = Get.find<AccountController>();
  bool loading = false;

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

  bool validateForm() {
    var fields = anamnesis.getFormFields();

    for (var field in fields) {
      if (field['value'] == null || field['value'] == '') {
        showAlert(
          'erro',
          'todos os campos são obrigatórios!',
          'error',
        );

        return false;
      }

      if (field['type'] == 'text' &&
          (field['value'].length < 3 ||
              field['value'].length > field['length'])) {
        showAlert(
          'erro',
          'o campo ${field['label']} deve ter entre 3 e ${field['length']} caracteres!',
          'error',
        );

        return false;
      }
    }

    return true;
  }

  void sendRequest() {
    if (validateForm() && !loading) {
      setState(() {
        loading = true;
      });

      createAnamnesis(accountController.token!, anamnesis, studentId)
          .then((value) {
        setState(() {
          loading = false;
        });

        if (value == 200) {
          showAlert(
              'anamnese criada', 'anamnese criada com sucesso!', 'success');

          Get.offAllNamed('/students-list');
        } else if (value == 401) {
          showAlert('sessão expirada',
              'sua sessão expirou, por favor, faça login novamente!', 'error');

          Get.offAllNamed('/login');
        } else {
          showAlert(
              'erro de conexão',
              'não foi possível conectar ao servidor, tente novamente mais tarde!',
              'error');
        }
      }).catchError((error) {
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var fields = anamnesis.getFormFields();

    return MasterPage(
      title: 'anamnese',
      showMenu: false,
      backButtonFunction: () => Get.back(),
      child: Container(
        width: width - 2 * defaultPadding,
        height: height - 2 * defaultPadding - 64,
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
                children: <Widget>[
                  SizedBox(
                    height: height - 140, // fixed height
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
                                    initialValue: fields[index]['value'] ?? '',
                                    keyboardType: TextInputType.text,
                                    style: GoogleFonts.manrope(
                                      color: fontColorGray,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
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
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: borderRadiusSmall,
                                        borderSide:
                                            BorderSide(color: bgColorWhiteDark),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
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
                                    onChanged: (value) {
                                      setState(() {
                                        anamnesis.updateValue(
                                            fields[index]['atribute'], value);
                                      });
                                    },
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
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: borderRadiusSmall,
                                        borderSide:
                                            BorderSide(color: bgColorWhiteDark),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
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
                                    value: fields[index]['value'] != null &&
                                            fields[index]['value'] != ''
                                        ? fields[index]['value']
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        anamnesis.updateValue(
                                            fields[index]['atribute'], value);
                                      });
                                    },
                                  ),
                            if (index == fields.length - 1)
                              const SizedBox(height: defaultMarginLarger),
                            if (index == fields.length - 1)
                              TextButton(
                                onPressed: () => {
                                  sendRequest(),
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(loading
                                          ? bgColorGray
                                          : statusColorSuccess),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    loading ? 'salvando...' : 'salvar',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: fontColorWhite,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            if (index == fields.length - 1)
                              TextButton(
                                onPressed: () => {
                                  Get.back(),
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          statusColorError),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'cancelar',
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
                        );
                      },
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
