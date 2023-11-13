import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/models/adm_tech.dart';
import 'package:unifit/models/teacher.dart';
import 'package:unifit/services/get_students.dart';
import 'package:unifit/services/get_teachers.dart';
import 'package:unifit/services/get_tecadm.dart';
import 'package:unifit/services/update_user.dart';
import 'package:unifit/utils/alert.dart';

import '../../components/page.dart';
import '../../constants.dart';
import '../../controllers/account_controller.dart';
import '../../enums/account_type.dart';
import '../../models/user.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreen();
}

class _EditUserScreen extends State<EditUserScreen> {
  int id = -1;
  AccountType type = AccountType.student;
  User user = User();
  Teacher teacher = Teacher();
  AdmTech admTech = AdmTech();
  bool loading = false;
  var accountController = Get.find<AccountController>();
  var fields = [];
  bool loadingFields = false;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(
        () {
          loadingFields = true;
          var queryParams = Get.parameters;

          if (queryParams['id'] != null) {
            id = int.parse(queryParams['id']!);
          }

          if (queryParams['type'] != null) {
            type = queryParams['type'] == 'aluno'
                ? AccountType.student
                : queryParams['type'] == 'professor'
                    ? AccountType.teacher
                    : AccountType.admin;

            getInfo();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getInfo() {
    var token = accountController.token!;

    if (type == AccountType.student) {
      getStudents(token).then(
        (value) => {
          for (var element in value)
            {
              if (element.idAluno == id)
                {
                  setState(
                    () {
                      user = element;
                      loadingFields = false;
                    },
                  )
                }
            }
        },
      );
    } else if (type == AccountType.teacher) {
      getTeachers(token).then(
        (value) => {
          for (var element in value)
            {
              if (element.idProfessor == id)
                {
                  setState(
                    () {
                      teacher = element;
                      loadingFields = false;
                    },
                  )
                }
            }
        },
      );
    } else if (type == AccountType.admin) {
      getTecAdm(token).then(
        (value) => {
          for (var element in value)
            {
              if (element.idTecnicoAdministrativo == id)
                {
                  setState(
                    () {
                      admTech = element;
                      loadingFields = false;
                    },
                  )
                }
            }
        },
      );
    }
  }

  bool validateForm() {
    var fieldsValidator = type == AccountType.student
        ? user.getFormFields()
        : type == AccountType.teacher
            ? teacher.getFormFields()
            : admTech.getFormFields();

    for (var field in fieldsValidator) {
      if ((field['value'] == null || field['value'] == '') && field['edit']) {
        showAlert(
          'erro',
          'todos os campos são obrigatórios!',
          'error',
        );

        return false;
      }

      if (field['type'] == 'text' &&
          (field['value'].length < 3 ||
              field['value'].length > field['length']) &&
          field['edit']) {
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
    var width = MediaQuery.of(context).size.width;
    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    if (validateForm() && !loading) {
      setState(() {
        loading = true;
      });

      updateUser(
              accountController.token!,
              type == AccountType.student
                  ? 'student'
                  : type == AccountType.teacher
                      ? 'teacher'
                      : 'tecadm',
              type == AccountType.student
                  ? user
                  : type == AccountType.teacher
                      ? teacher
                      : admTech,
              id)
          .then(
            (value) => {
              setState(
                () {
                  loading = false;
                },
              ),
              if (value == 200) Get.toNamed('/students-list'),
            },
          )
          .catchError(
            (error) => {
              setState(
                () {
                  loading = false;
                },
              ),
            },
          );
    }
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
    var fields = type == AccountType.student
        ? user.getFormFields()
        : type == AccountType.teacher
            ? teacher.getFormFields()
            : admTech.getFormFields();

    return MasterPage(
      title: type == AccountType.student
          ? 'atualizar aluno'
          : type == AccountType.teacher
              ? 'atualizar professor'
              : 'atualizar téc. adm.',
      showMenu: false,
      child: Column(
        children: <Widget>[
          loadingFields
              ? SizedBox(
                  height: height - 80,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: bgColorBlueNormal,
                    ),
                  ),
                )
              : Container(
                  height: type == AccountType.student
                      ? height - 450
                      : type == AccountType.teacher
                          ? height - 530
                          : height - 530,
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: ListView.builder(
                    itemCount: fields.length,
                    itemBuilder: (context, index) {
                      return fields[index]['edit']
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: defaultMarginLarge),
                                fields[index]['type'] != 'checkbox'
                                    ? Text(
                                        fields[index]['label'],
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: fontColorGray,
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                    : Container(),
                                const SizedBox(height: defaultMarginSmall),
                                fields[index]['type'] == 'date'
                                    ? InkWell(
                                        onTap: () => {
                                          showDatePicker(
                                            context: context,
                                            currentDate:
                                                DateTime.now().subtract(
                                              const Duration(hours: 3),
                                            ),
                                            initialDate: DateTime(2021, 1, 1),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100),
                                            confirmText: 'Confirmar',
                                            cancelText: 'Cancelar',
                                            helpText:
                                                'Selecione a data de nascimento',
                                          ).then((value) => {
                                                if (value != null)
                                                  {
                                                    setState(() {
                                                      if (type ==
                                                          AccountType.student) {
                                                        user.updateValue(
                                                            fields[index]
                                                                ['atribute'],
                                                            value);
                                                      } else if (type ==
                                                          AccountType.teacher) {
                                                        teacher.updateValue(
                                                            fields[index]
                                                                ['atribute'],
                                                            value);
                                                      } else if (type ==
                                                          AccountType.admin) {
                                                        admTech.updateValue(
                                                            fields[index]
                                                                ['atribute'],
                                                            value);
                                                      }
                                                    })
                                                  }
                                              })
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 34,
                                          alignment: Alignment.center,
                                          transformAlignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal:
                                                  defaultPaddingFieldsHorizontal),
                                          decoration: const BoxDecoration(
                                            color: bgColorWhiteNormal,
                                            borderRadius: borderRadiusSmall,
                                            border: Border.fromBorderSide(
                                              BorderSide(
                                                  color: bgColorWhiteDark),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                color: fontColorGray,
                                                size: 16,
                                              ),
                                              const SizedBox(
                                                  width: defaultMarginMedium),
                                              Text(
                                                fields[index]['value'] !=
                                                            null &&
                                                        fields[index]
                                                                ['value'] !=
                                                            ''
                                                    ? formatDateTime(
                                                        fields[index]['value'])
                                                    : 'selecione',
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: fontColorGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : fields[index]['type'] != 'select' &&
                                            fields[index]['type'] != 'checkbox'
                                        ? TextFormField(
                                            initialValue:
                                                fields[index]['value'] ?? '',
                                            keyboardType: fields[index]
                                                        ['type'] ==
                                                    'number'
                                                ? TextInputType.number
                                                : fields[index]['type'] ==
                                                        'email'
                                                    ? TextInputType.emailAddress
                                                    : fields[index]['type'] ==
                                                            'phone'
                                                        ? TextInputType.phone
                                                        : fields[index]
                                                                    ['type'] ==
                                                                'password'
                                                            ? TextInputType
                                                                .visiblePassword
                                                            : fields[index][
                                                                        'type'] ==
                                                                    'multiline'
                                                                ? TextInputType
                                                                    .multiline
                                                                : TextInputType
                                                                    .text,
                                            obscureText: fields[index]
                                                        ['type'] ==
                                                    'password'
                                                ? true
                                                : false,
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
                                              fillColor: bgColorWhiteNormal,
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
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  if (type ==
                                                      AccountType.student) {
                                                    user.updateValue(
                                                        fields[index]
                                                            ['atribute'],
                                                        value);
                                                  } else if (type ==
                                                      AccountType.teacher) {
                                                    teacher.updateValue(
                                                        fields[index]
                                                            ['atribute'],
                                                        value);
                                                  } else if (type ==
                                                      AccountType.admin) {
                                                    admTech.updateValue(
                                                        fields[index]
                                                            ['atribute'],
                                                        value);
                                                  }
                                                },
                                              );
                                            },
                                          )
                                        : fields[index]['type'] == 'select'
                                            ? DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .never,
                                                  isDense: true,
                                                  hintStyle:
                                                      GoogleFonts.manrope(
                                                    color: fontColorGray,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  filled: true,
                                                  fillColor: bgColorWhiteNormal,
                                                  hintText: fields[index]
                                                      ['label'],
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
                                                items: [
                                                  for (var option
                                                      in fields[index]
                                                              ['options']
                                                          as List<String>)
                                                    DropdownMenuItem(
                                                      value: option,
                                                      child: Text(option),
                                                    ),
                                                ],
                                                value: fields[index]['value'],
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      if (type ==
                                                          AccountType.student) {
                                                        if (fields[index]
                                                                ['atribute'] ==
                                                            'anoIngresso') {
                                                          user.updateValue(
                                                              fields[index]
                                                                  ['atribute'],
                                                              int.parse(value
                                                                  as String));
                                                        } else {
                                                          user.updateValue(
                                                              fields[index]
                                                                  ['atribute'],
                                                              value);
                                                        }
                                                      } else if (type ==
                                                          AccountType.teacher) {
                                                        teacher.updateValue(
                                                            fields[index]
                                                                ['atribute'],
                                                            value);
                                                      } else if (type ==
                                                          AccountType.admin) {
                                                        admTech.updateValue(
                                                            fields[index]
                                                                ['atribute'],
                                                            value);
                                                      }
                                                    },
                                                  );
                                                },
                                              )
                                            : CheckboxListTile(
                                                title: Text(
                                                    fields[index]['label']),
                                                value: fields[index]['value'] ??
                                                    false,
                                                onChanged: (value) {
                                                  setState(() {
                                                    if (type ==
                                                        AccountType.student) {
                                                      user.updateValue(
                                                          fields[index]
                                                              ['atribute'],
                                                          value);
                                                    } else if (type ==
                                                        AccountType.teacher) {
                                                      teacher.updateValue(
                                                          fields[index]
                                                              ['atribute'],
                                                          value);
                                                    } else if (type ==
                                                        AccountType.admin) {
                                                      admTech.updateValue(
                                                          fields[index]
                                                              ['atribute'],
                                                          value);
                                                    }
                                                  });
                                                },
                                                controlAffinity:
                                                    ListTileControlAffinity
                                                        .leading,
                                                enabled: true,
                                              ),
                              ],
                            )
                          : Container();
                    },
                  ),
                ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Column(
              children: [
                const SizedBox(height: defaultMarginLarger),
                TextButton(
                  onPressed: () => {sendRequest()},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        loading ? bgColorGray : statusColorInfo),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      loading ? 'atualizando...' : 'atualizar',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
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
                        MaterialStateProperty.all<Color>(statusColorError),
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
            ),
          )
        ],
      ),
    );
  }
}
