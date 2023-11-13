import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/page.dart';
import 'package:unifit/components/student_card.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/adm_tech.dart';
import 'package:unifit/models/teacher.dart';
import 'package:unifit/models/user.dart';
import 'package:unifit/services/create_frequency.dart';
import 'package:unifit/services/delete_student.dart';
import 'package:unifit/services/delete_teacher.dart';
import 'package:unifit/services/delete_tecadm.dart';
import 'package:unifit/services/get_students.dart';
import 'package:unifit/services/get_teachers.dart';
import 'package:unifit/services/get_tecadm.dart';

import '../../components/button.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreen();
}

class _UserListScreen extends State<UserListScreen> {
  List<dynamic> users = [];
  List<dynamic> usersFiltered = [];
  String search = '';

  bool loadingStudents = false;
  bool loadingTeachers = false;
  bool loadingAdmins = false;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      var accountController = Get.find<AccountController>();

      var type = accountController.type!;
      String token = accountController.token!;

      loadingStudents = true;

      getStudents(token).then(
        (value) => {
          if (mounted)
            setState(
              () {
                var allUsers = [];

                for (var element in value) {
                  var user = {
                    'id': element.idAluno,
                    'matricula': element.matricula,
                    'nome': element.nome,
                    'curso': element.curso,
                    'nascimento': element.nascimento,
                    'tipo': 'aluno',
                  };

                  allUsers.add(
                    user,
                  );
                }

                allUsers.sort(
                  (a, b) {
                    return a['matricula'].compareTo(b['matricula']);
                  },
                );

                for (var element in allUsers) {
                  users.add(
                    element,
                  );
                }

                users.sort(
                  (a, b) {
                    return a['tipo'].compareTo(b['tipo']);
                  },
                );

                usersFiltered = users;

                loadingStudents = false;
              },
            )
        },
      );

      if (type == 1) {
        loadingTeachers = true;

        getTeachers(token).then(
          (value) => {
            if (mounted)
              setState(
                () {
                  var allUsers = [];

                  for (var element in value) {
                    var user = {
                      'id': element.idProfessor,
                      'matricula': element.idProfessor.toString(),
                      'nome': element.nome,
                      'nascimento': element.nascimento,
                      'curso': 'N/A',
                      'tipo': 'professor',
                    };

                    allUsers.add(
                      user,
                    );
                  }

                  allUsers.sort(
                    (a, b) {
                      return a['matricula'].compareTo(b['matricula']);
                    },
                  );

                  for (var element in allUsers) {
                    users.add(
                      element,
                    );
                  }

                  users.sort(
                    (a, b) {
                      return a['tipo'].compareTo(b['tipo']);
                    },
                  );

                  usersFiltered = users;

                  loadingTeachers = false;
                },
              )
          },
        );

        loadingAdmins = true;
        getTecAdm(token).then(
          (value) => {
            if (mounted)
              setState(
                () {
                  var allUsers = [];

                  for (var element in value) {
                    var user = {
                      'id': element.idTecnicoAdministrativo,
                      'matricula': element.idTecnicoAdministrativo.toString(),
                      'nome': element.nome,
                      'nascimento': element.nascimento,
                      'curso': 'N/A',
                      'tipo': 'tec',
                    };

                    allUsers.add(
                      user,
                    );
                  }

                  allUsers.sort(
                    (a, b) {
                      return a['matricula'].compareTo(b['matricula']);
                    },
                  );

                  for (var element in allUsers) {
                    users.add(
                      element,
                    );
                  }

                  users.sort(
                    (a, b) {
                      return a['tipo'].compareTo(b['tipo']);
                    },
                  );

                  usersFiltered = users;

                  loadingAdmins = false;
                },
              )
          },
        );
      } else {
        loadingTeachers = false;
        loadingAdmins = false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void delete(int id, String tipo) {
    var accountController = Get.find<AccountController>();
    var token = accountController.token!;

    if (tipo == 'aluno') {
      deleteStudent(token, id);
    } else if (tipo == 'professor') {
      deleteTeacher(token, id);
    } else if (tipo == 'tec') {
      deleteTecadm(token, id);
    }
  }

  void deleteUser(int id, String tipo) {
    var width = MediaQuery.of(context).size.width;

    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    Get.dialog(
      Center(
        child: Container(
          width: dialogSize,
          height: 190,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: bgColorWhiteNormal,
            borderRadius: borderRadiusSmall,
            boxShadow: [boxShadowDefault],
          ),
          child: Column(
            children: [
              Text(
                'deseja realmente desativar o usuário?',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: fontColorGray,
                  textStyle: const TextStyle(
                    decoration: TextDecoration.none,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => {
                  Get.back(),
                  delete(id, tipo),
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(statusColorWarning),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'desativar',
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
            ],
          ),
        ),
      ),
    );
  }

  void registerFrequency(int studentId) {
    var accountController = Get.find<AccountController>();

    String token = accountController.token!;
    int admId = accountController.admtech!.idTecnicoAdministrativo;

    admId == -1 ? admId = 1 : admId = admId;

    createFrequency(token, studentId, admId).then(
      (value) => {
        if (value == 200)
          {
            setState(
              () {
                loadingStudents = false;
                loadingTeachers = false;
                loadingAdmins = false;
              },
            )
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    var accountController = Get.find<AccountController>();
    var type = accountController.type!;

    return MasterPage(
      title: 'usuários cadastrados',
      showBackButton: false,
      showMenu: type == 1 ? true : false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width - 2 * defaultPadding,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  type == 1
                      ? InkWell(
                          child: Container(
                            width: 34,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: statusColorSuccess,
                              borderRadius: borderRadiusSmall,
                              boxShadow: [boxShadowDefault],
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: fontColorWhite,
                              size: 24,
                            ),
                          ),
                          onTap: () => {
                            Get.dialog(
                              Center(
                                child: Container(
                                  width: dialogSize,
                                  height: 284,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(defaultPadding),
                                  decoration: const BoxDecoration(
                                    color: bgColorWhiteNormal,
                                    borderRadius: borderRadiusSmall,
                                    boxShadow: [boxShadowDefault],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'selecione a opção desejada',
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: fontColorGray,
                                          textStyle: const TextStyle(
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      TextButton(
                                        onPressed: () => {
                                          Get.back(),
                                          Get.toNamed('/new-user/student'),
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  bgColorBlueLightSecondary),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'cadastrar aluno',
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
                                          Get.toNamed('/new-user/teacher'),
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  bgColorBlueLightSecondary),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'cadastrar professor',
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
                                          Get.toNamed('/new-user/admin'),
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  bgColorBlueLightSecondary),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'cadastrar téc. adm.',
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
                                              MaterialStateProperty.all<Color>(
                                                  statusColorError),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
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
                          },
                        )
                      : Container(),
                  SizedBox(
                    width: type == 1 ? 304 : width - 2 * defaultPadding,
                    height: 34,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: bgColorWhiteNormal,
                        borderRadius: borderRadiusSmall,
                        boxShadow: [boxShadowDefault],
                      ),
                      child: TextField(
                        onChanged: (value) => {
                          setState(() {
                            search = value;

                            if (search.isEmpty) {
                              usersFiltered = users;
                            } else {
                              usersFiltered = users
                                  .where((element) =>
                                      element['nome']
                                          .toLowerCase()
                                          .contains(search.toLowerCase()) ||
                                      element['matricula']
                                          .toLowerCase()
                                          .contains(search.toLowerCase()) ||
                                      element['curso']
                                          .toLowerCase()
                                          .contains(search.toLowerCase()))
                                  .toList();
                            }
                          })
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
                                onTap: () => {},
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
          ),
          const SizedBox(height: 16),
          !loadingStudents && !loadingTeachers && !loadingAdmins
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: height - 206, // fixed height
                      child: ListView.builder(
                        itemCount: usersFiltered.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              if (index > 0 &&
                                  usersFiltered[index - 1]['tipo'] !=
                                      usersFiltered[index]['tipo'])
                                Container(
                                  width: width - 2 * defaultPadding - 24,
                                  height: 1,
                                  color: fontColorBlue,
                                  margin: const EdgeInsets.only(
                                    bottom: defaultPadding - 12,
                                  ),
                                ),
                              StudentCard(
                                registration: usersFiltered[index]['tipo'] ==
                                        'aluno'
                                    ? "aluno ${usersFiltered[index]['matricula']}"
                                    : usersFiltered[index]['tipo'] ==
                                            'professor'
                                        ? "professor ${usersFiltered[index]['matricula']}"
                                        : "téc. adm. ${usersFiltered[index]['matricula']}",
                                name: usersFiltered[index]['nome'],
                                course: usersFiltered[index]['curso'],
                                birthDate: usersFiltered[index]['nascimento']
                                    .toString(),
                                onTap: () => {
                                  Get.dialog(
                                    Center(
                                      child: Container(
                                        width: dialogSize,
                                        height: type == 1 &&
                                                usersFiltered[index]['tipo'] ==
                                                    'aluno' &&
                                                accountController
                                                    .teacher!.isEstagiario
                                            ? 360
                                            : type == 1 &&
                                                    usersFiltered[index]
                                                            ['tipo'] ==
                                                        'aluno'
                                                ? 450
                                                : type == 1
                                                    ? 260
                                                    : 210,
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
                                            Text(
                                              usersFiltered[index]['tipo'] ==
                                                      'aluno'
                                                  ? "aluno ${usersFiltered[index]['matricula']}"
                                                  : usersFiltered[index]
                                                              ['tipo'] ==
                                                          'professor'
                                                      ? "professor ${usersFiltered[index]['matricula']}"
                                                      : "téc. adm. ${usersFiltered[index]['matricula']}",
                                              style: GoogleFonts.roboto(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: fontColorBlue,
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: fontColorBlue,
                                                decorationThickness: 2,
                                                decorationStyle:
                                                    TextDecorationStyle.solid,
                                                textStyle: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              'selecione a opção desejada',
                                              style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: fontColorGray,
                                                textStyle: const TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                ),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 24),
                                            type == 1 &&
                                                    usersFiltered[index]
                                                            ['tipo'] ==
                                                        'aluno'
                                                ? ButtonSecondary(
                                                    hintText:
                                                        'frequência do aluno',
                                                    type: ButtonType.info,
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          "/student-frequency/${usersFiltered[index]['id']}"),
                                                    },
                                                  )
                                                : Container(),
                                            type == 1 &&
                                                    usersFiltered[index]
                                                            ['tipo'] ==
                                                        'aluno'
                                                ? ButtonSecondary(
                                                    hintText: 'fichas do aluno',
                                                    type: ButtonType.info,
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          "/student-sheets/${usersFiltered[index]['id']}"),
                                                    },
                                                  )
                                                : Container(),
                                            type == 1 &&
                                                    usersFiltered[index]
                                                            ['tipo'] ==
                                                        'aluno'
                                                ? ButtonSecondary(
                                                    hintText:
                                                        'avaliações do aluno',
                                                    type: ButtonType.info,
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          "/user-physical-assessments/${usersFiltered[index]['id']}"),
                                                    },
                                                  )
                                                : Container(),
                                            type == 1 &&
                                                    usersFiltered[index]
                                                            ['tipo'] ==
                                                        'aluno'
                                                ? ButtonSecondary(
                                                    hintText:
                                                        'anamnese do aluno',
                                                    type: ButtonType.info,
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          "/new-user-anamnesis/${usersFiltered[index]['id']}"),
                                                    },
                                                  )
                                                : Container(),
                                            type == 1 &&
                                                    accountController.teacher !=
                                                        null &&
                                                    !accountController
                                                        .teacher!.isEstagiario
                                                ? ButtonSecondary(
                                                    hintText: 'atualizar',
                                                    type: ButtonType.success,
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          "/edit-user/${usersFiltered[index]['tipo']}/${usersFiltered[index]['id']}"),
                                                    },
                                                  )
                                                : Container(),
                                            type == 1 &&
                                                    accountController.teacher !=
                                                        null &&
                                                    !accountController
                                                        .teacher!.isEstagiario
                                                ? ButtonSecondary(
                                                    hintText: 'desativar',
                                                    type: ButtonType.warning,
                                                    onPressed: () => {
                                                      Get.back(),
                                                      deleteUser(
                                                          usersFiltered[index]
                                                              ['id'],
                                                          usersFiltered[index]
                                                              ['tipo']),
                                                    },
                                                  )
                                                : Container(),
                                            type != 1 &&
                                                    usersFiltered[index]
                                                            ['tipo'] ==
                                                        'aluno'
                                                ? ButtonSecondary(
                                                    hintText: 'marcar presença',
                                                    type: ButtonType.success,
                                                    onPressed: () => {
                                                      registerFrequency(
                                                          usersFiltered[index]
                                                              ['id']),
                                                      Get.back(),
                                                    },
                                                  )
                                                : Container(),
                                            ButtonSecondary(
                                              hintText: 'fechar',
                                              type: ButtonType.danger,
                                              onPressed: () => {
                                                Get.back(),
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
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
          type != 1
              ? SizedBox(
                  width: width - 2 * defaultPadding,
                  child: TextButton(
                    onPressed: () => {
                      accountController.logout(),
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(statusColorError),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'sair',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: fontColorWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
