import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/components/page.dart';
import 'package:unifit/components/student_card.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';
import 'package:unifit/models/user.dart';
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

    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    return MasterPage(
      title: 'alunos cadastrados',
      showBackButton: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: statusColorSuccess,
                  borderRadius: borderRadiusSmall,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: fontColorWhite,
                  size: 24,
                ),
              ),
              onTap: () => {
                print('adicionar aluno'),
              },
            ),
            SizedBox(
              width: 304,
              height: 34,
              child: Container(
                decoration: const BoxDecoration(
                  color: bgColorWhiteNormal,
                  borderRadius: borderRadiusSmall,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
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
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    isDense: true,
                    hintStyle: GoogleFonts.manrope(
                      color: fontColorGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
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
                                            element.nome.toLowerCase().contains(
                                                search.toLowerCase()) ||
                                            element.matricula
                                                .toLowerCase()
                                                .contains(
                                                    search.toLowerCase()) ||
                                            element.curso
                                                .toLowerCase()
                                                .contains(search.toLowerCase()))
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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
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
          Column(
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
                          birthDate:
                              studentsFiltered[index].nascimento.toString(),
                          onTap: () => {
                            Get.dialog(
                              Center(
                                child: Container(
                                  width: dialogSize,
                                  height: 360,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(defaultPadding),
                                  decoration: const BoxDecoration(
                                    color: bgColorWhiteNormal,
                                    borderRadius: borderRadiusSmall,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        studentsFiltered[index].matricula,
                                        style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          color: fontColorBlue,
                                          decoration: TextDecoration.underline,
                                          decorationColor: fontColorBlue,
                                          decorationThickness: 2,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
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
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      TextButton(
                                        onPressed: () => {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  bgColorBlueLightSecondary),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'frequência do aluno',
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
                                        onPressed: () => {},
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  bgColorBlueLightSecondary),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'planos do aluno',
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
                                          Get.toNamed(
                                              '/user-physical-assessments/${studentsFiltered[index].idAluno}'),
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  bgColorBlueLightSecondary),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'avaliações do aluno',
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
                                          Get.toNamed(
                                              '/new-user-anamnesis/${studentsFiltered[index].idAluno}'),
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  bgColorBlueLightSecondary),
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            'anamnese do aluno',
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
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
