import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/page.dart';
import 'package:unifit/components/student_card.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/user.dart';
import 'package:unifit/services/create_frequency.dart';
import 'package:unifit/services/get_students.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreen();
}

class _UserListScreen extends State<UserListScreen> {
  List<User> students = [];
  List<User> studentsFiltered = [];
  String search = '';
  bool loading = true;

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
                students = value;
                studentsFiltered = value;
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
                loading = false;
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
      title: 'alunos cadastrados',
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
                              studentsFiltered = students;
                            } else {
                              studentsFiltered = students
                                  .where((element) =>
                                      element.nome
                                          .toLowerCase()
                                          .contains(search.toLowerCase()) ||
                                      element.matricula
                                          .toLowerCase()
                                          .contains(search.toLowerCase()) ||
                                      element.curso
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
                                onTap: () => {
                                      setState(() {
                                        if (search.isEmpty) {
                                          studentsFiltered = students;
                                        } else {
                                          studentsFiltered = students
                                              .where((element) =>
                                                  element.nome
                                                      .toLowerCase()
                                                      .contains(search
                                                          .toLowerCase()) ||
                                                  element.matricula
                                                      .toLowerCase()
                                                      .contains(search
                                                          .toLowerCase()) ||
                                                  element.curso
                                                      .toLowerCase()
                                                      .contains(
                                                          search.toLowerCase()))
                                              .toList();
                                        }
                                      })
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
          ),
          const SizedBox(height: 16),
          !loading
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: height - 206, // fixed height
                      child: ListView.builder(
                        itemCount: studentsFiltered.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              StudentCard(
                                registration: studentsFiltered[index].matricula,
                                name: studentsFiltered[index].nome,
                                course: studentsFiltered[index].curso,
                                birthDate: studentsFiltered[index]
                                    .nascimento
                                    .toString(),
                                onTap: () => {
                                  Get.dialog(
                                    Center(
                                      child: Container(
                                        width: dialogSize,
                                        height: type == 1 ? 360 : 210,
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
                                              studentsFiltered[index].matricula,
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
                                            type == 1
                                                ? TextButton(
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          '/student-frequency/${studentsFiltered[index].idAluno}'),
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              bgColorBlueLightSecondary),
                                                    ),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        'frequência do aluno',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: fontColorWhite,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            type == 1
                                                ? TextButton(
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          '/student-sheets/${studentsFiltered[index].idAluno}'),
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              bgColorBlueLightSecondary),
                                                    ),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        'fichas do aluno',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: fontColorWhite,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            type == 1
                                                ? TextButton(
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          '/user-physical-assessments/${studentsFiltered[index].idAluno}'),
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              bgColorBlueLightSecondary),
                                                    ),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        'avaliações do aluno',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: fontColorWhite,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            type == 1
                                                ? TextButton(
                                                    onPressed: () => {
                                                      Get.back(),
                                                      Get.toNamed(
                                                          '/new-user-anamnesis/${studentsFiltered[index].idAluno}'),
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty.all<
                                                                  Color>(
                                                              bgColorBlueLightSecondary),
                                                    ),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: Text(
                                                        'anamnese do aluno',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: fontColorWhite,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            type != 1
                                                ? TextButton(
                                                    onPressed: () => {
                                                      registerFrequency(
                                                          studentsFiltered[
                                                                  index]
                                                              .idAluno),
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
                                                        'marcar presença',
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                          color: fontColorWhite,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
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
