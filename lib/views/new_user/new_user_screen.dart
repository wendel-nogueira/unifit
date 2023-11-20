import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:unifit/models/adm_tech.dart';
import 'package:unifit/models/teacher.dart';
import 'package:unifit/services/get_students.dart';
import 'package:unifit/services/get_teachers.dart';
import 'package:unifit/services/get_tecadm.dart';
import 'package:unifit/utils/alert.dart';

import '../../components/page.dart';
import '../../constants.dart';
import '../../controllers/account_controller.dart';
import '../../enums/account_type.dart';
import '../../models/user.dart';
import '../../services/create_user.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});

  @override
  State<NewUserScreen> createState() => _NewUserScreen();
}

class _NewUserScreen extends State<NewUserScreen> {
  User newUser = User();
  Teacher newTeacher = Teacher();
  AdmTech newAdmTech = AdmTech();
  AccountType? type;
  bool loading = false;
  var accountController = Get.find<AccountController>();
  var fields = [];
  bool loadingFields = false;

  List<User> students = [];
  List<Teacher> teachers = [];
  List<AdmTech> admTechs = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        var queryParams = Get.parameters;
        var token = accountController.token!;

        if (queryParams['type'] != null) {
          type = queryParams['type'] == 'student'
              ? AccountType.student
              : queryParams['type'] == 'teacher'
                  ? AccountType.teacher
                  : AccountType.admin;

          if (type == AccountType.student) {
            fields = newUser.getFormFields();

            getStudents(token).then(
              (value) => {
                setState(
                  () {
                    students = value;
                  },
                ),
              },
            );
          } else if (type == AccountType.teacher) {
            fields = newTeacher.getFormFields();

            getTeachers(token).then(
              (value) => {
                setState(
                  () {
                    teachers = value;
                  },
                ),
              },
            );
          } else if (type == AccountType.admin) {
            fields = newAdmTech.getFormFields();

            getTecAdm(token).then(
              (value) => {
                setState(
                  () {
                    admTechs = value;
                  },
                ),
              },
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool validateForm() {
    var fieldsValidator = type == AccountType.student
        ? newUser.getFormFields()
        : type == AccountType.teacher
            ? newTeacher.getFormFields()
            : newAdmTech.getFormFields();

    var emailExists = false;

    if (type == AccountType.student) {
      emailExists = students.any((element) => element.email == newUser.email);
    } else if (type == AccountType.teacher) {
      emailExists =
          teachers.any((element) => element.email == newTeacher.email);
    } else {
      emailExists =
          admTechs.any((element) => element.email == newAdmTech.email);
    }

    if (emailExists) {
      showAlert(
        'erro',
        'o e-mail informado já está cadastrado!',
        'error',
      );

      return false;
    }

    for (var field in fieldsValidator) {
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

      const regexNotNumber = r'^[a-zA-Z]+$';
      const regexEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

      if (field['atribute'] == 'nome' &&
          !RegExp(regexNotNumber).hasMatch(field['value'])) {
        showAlert(
          'erro',
          'o campo ${field['label']} não pode conter números!',
          'error',
        );

        return false;
      }

      if (field['atribute'] == 'senha' && field['value'].length < 8) {
        showAlert(
          'erro',
          'o campo ${field['label']} deve ter no mínimo 8 caracteres!',
          'error',
        );

        return false;
      }

      if (field['atribute'] == 'email' &&
          !RegExp(regexEmail).hasMatch(field['value'])) {
        showAlert(
          'erro',
          'o campo ${field['label']} deve ser um e-mail válido!',
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

      createUser(
              accountController.token!,
              type == AccountType.student
                  ? 'student'
                  : type == AccountType.teacher
                      ? 'teacher'
                      : 'tecadm',
              type == AccountType.student
                  ? newUser
                  : type == AccountType.teacher
                      ? newTeacher
                      : newAdmTech)
          .then(
            (value) => {
              setState(
                () {
                  loading = false;
                },
              ),
              if (value == 201) Get.toNamed('/students-list'),
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
        ? newUser.getFormFields()
        : type == AccountType.teacher
            ? newTeacher.getFormFields()
            : newAdmTech.getFormFields();

    return MasterPage(
      title: type == AccountType.student
          ? 'novo aluno'
          : type == AccountType.teacher
              ? 'novo professor'
              : 'novo téc. adm.',
      showMenu: false,
      child: Column(
        children: <Widget>[
          Container(
            height: height - 80,
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: ListView.builder(
              itemCount: fields.length,
              itemBuilder: (context, index) {
                return Column(
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
                                currentDate: DateTime.now().subtract(
                                  const Duration(hours: 3),
                                ),
                                initialDate: DateTime(2021, 1, 1),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                                confirmText: 'Confirmar',
                                cancelText: 'Cancelar',
                                helpText: 'Selecione a data de nascimento',
                              ).then((value) => {
                                    if (value != null)
                                      {
                                        setState(() {
                                          if (type == AccountType.student) {
                                            newUser.updateValue(
                                                fields[index]['atribute'],
                                                value);
                                          } else if (type ==
                                              AccountType.teacher) {
                                            newTeacher.updateValue(
                                                fields[index]['atribute'],
                                                value);
                                          } else if (type ==
                                              AccountType.admin) {
                                            newAdmTech.updateValue(
                                                fields[index]['atribute'],
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
                                  horizontal: defaultPaddingFieldsHorizontal),
                              decoration: const BoxDecoration(
                                color: bgColorWhiteNormal,
                                borderRadius: borderRadiusSmall,
                                border: Border.fromBorderSide(
                                  BorderSide(color: bgColorWhiteDark),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: fontColorGray,
                                    size: 16,
                                  ),
                                  const SizedBox(width: defaultMarginMedium),
                                  Text(
                                    fields[index]['value'] != null &&
                                            fields[index]['value'] != ''
                                        ? formatDateTime(fields[index]['value'])
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
                                initialValue: fields[index]['value'] ?? '',
                                keyboardType: fields[index]['type'] == 'number'
                                    ? TextInputType.number
                                    : fields[index]['type'] == 'email'
                                        ? TextInputType.emailAddress
                                        : fields[index]['type'] == 'phone'
                                            ? TextInputType.phone
                                            : fields[index]['type'] ==
                                                    'password'
                                                ? TextInputType.visiblePassword
                                                : fields[index]['type'] ==
                                                        'multiline'
                                                    ? TextInputType.multiline
                                                    : TextInputType.text,
                                obscureText: fields[index]['type'] == 'password'
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
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: borderRadiusSmall,
                                    borderSide:
                                        BorderSide(color: bgColorWhiteDark),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: borderRadiusSmall,
                                    borderSide:
                                        BorderSide(color: bgColorBlueNormal),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: defaultPaddingFieldsVertical,
                                      horizontal:
                                          defaultPaddingFieldsHorizontal),
                                ),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      if (type == AccountType.student) {
                                        newUser.updateValue(
                                            fields[index]['atribute'], value);
                                      } else if (type == AccountType.teacher) {
                                        newTeacher.updateValue(
                                            fields[index]['atribute'], value);
                                      } else if (type == AccountType.admin) {
                                        newAdmTech.updateValue(
                                            fields[index]['atribute'], value);
                                      }
                                    },
                                  );
                                },
                              )
                            : fields[index]['type'] == 'select'
                                ? DropdownButtonFormField(
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
                                    onChanged: (value) {
                                      setState(() {
                                        if (type == AccountType.student) {
                                          if (fields[index]['atribute'] ==
                                              'anoIngresso') {
                                            newUser.updateValue(
                                                fields[index]['atribute'],
                                                int.parse(value!));
                                          } else {
                                            newUser.updateValue(
                                                fields[index]['atribute'],
                                                value);
                                          }
                                        } else if (type ==
                                            AccountType.teacher) {
                                          newTeacher.updateValue(
                                              fields[index]['atribute'], value);
                                        } else if (type == AccountType.admin) {
                                          newAdmTech.updateValue(
                                              fields[index]['atribute'], value);
                                        }
                                      });
                                    },
                                  )
                                : CheckboxListTile(
                                    title: Text(fields[index]['label']),
                                    value: fields[index]['value'] ?? false,
                                    onChanged: (value) {
                                      setState(() {
                                        if (type == AccountType.student) {
                                          newUser.updateValue(
                                              fields[index]['atribute'], value);
                                        } else if (type ==
                                            AccountType.teacher) {
                                          newTeacher.updateValue(
                                              fields[index]['atribute'], value);
                                        } else if (type == AccountType.admin) {
                                          newAdmTech.updateValue(
                                              fields[index]['atribute'], value);
                                        }
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    enabled: true,
                                  ),
                    if (index == fields.length - 1)
                      const SizedBox(height: defaultMarginLarger),
                    if (index == fields.length - 1)
                      TextButton(
                        onPressed: () => {sendRequest()},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              loading ? bgColorGray : statusColorSuccess),
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
                          backgroundColor: MaterialStateProperty.all<Color>(
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
        ],
      ),
    );
  }
}
