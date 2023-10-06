import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/models/assessment.dart';
import 'package:unifit/services/create_anamnesis.dart';
import 'package:unifit/services/create_assessment.dart';
import 'package:unifit/utils/alert.dart';

import '../../components/page.dart';
import '../../constants.dart';
import '../../controllers/account_controller.dart';
import '../../services/get_students.dart';

class NewPhysicalAssessmentScreen extends StatefulWidget {
  const NewPhysicalAssessmentScreen({super.key});

  @override
  State<NewPhysicalAssessmentScreen> createState() =>
      _NewPhysicalAssessmentScreen();
}

class _NewPhysicalAssessmentScreen extends State<NewPhysicalAssessmentScreen> {
  int studentId = -1;
  Assessment assessment = Assessment();
  bool loadingStudent = true;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(
        () {
          var queryParams = Get.parameters;

          if (queryParams['id'] != null) {
            studentId = int.parse(queryParams['id']!);

            loadingStudent = false;
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool validateForm() {
    var fields = assessment.getFormFields();

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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var fields = assessment.getFormFields();
    var accountController = Get.find<AccountController>();

    return MasterPage(
      title: 'nova avaliação',
      showMenu: false,
      child: Column(
        children: <Widget>[
          !loadingStudent
              ? SizedBox(
                  height: height - 80, // fixed height
                  child: ListView.builder(
                    itemCount: fields.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              isDense: true,
                              hintStyle: GoogleFonts.manrope(
                                color: fontColorGray,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                              filled: true,
                              fillColor: bgColorWhiteDark,
                              hintText: fields[index]['label'],
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
                            ),
                            onChanged: (value) {
                              setState(() {
                                assessment.updateValue(
                                    fields[index]['atribute'], value);
                              });
                            },
                          ),
                          if (index == fields.length - 1)
                            const SizedBox(height: defaultMarginLarger),
                          if (index == fields.length - 1)
                            TextButton(
                              onPressed: () => {
                                if (validateForm())
                                  {
                                    createAssessment(accountController.token!,
                                            assessment, studentId)
                                        .then((value) {
                                      if (value == 200) {
                                        Get.back();
                                      }
                                    })
                                  }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        statusColorSuccess),
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'salvar',
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
                          const SizedBox(height: defaultMarginLarge),
                        ],
                      );
                    },
                  ),
                )
              : Center(
                  child: Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: const CircularProgressIndicator())),
        ],
      ),
    );
  }
}
