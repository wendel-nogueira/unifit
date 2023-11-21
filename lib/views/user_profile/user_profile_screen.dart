import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/constants.dart';
import 'package:unifit/controllers/account_controller.dart';
import '../../components/page.dart';
import '../../services/send_feedback_email.service.dart';
import '../../services/update_peso.dart';
import '../../services/update_user.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreen();
}

class _UserProfileScreen extends State<UserProfileScreen> {
  bool loading = false;
  final account = Get.find<AccountController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void sendRequest(double peso, String objetivo) async {
    var token = Get.find<AccountController>().token!;
    var id = Get.find<AccountController>().user!.idAluno;
    var user = Get.find<AccountController>().user;

    setState(() {
      loading = true;
    });

    if (objetivo != user!.objetivo) {
      setState(() {
        account.user!.objetivo = objetivo;
      });

      await updateUser(token, 'student', user, id);
    }

    if (peso != user.peso) {
      setState(() {
        account.user!.peso = peso;
        account.user!.imc = peso / ((user.altura / 100) * (user.altura / 100));
      });

      await updatePeso(token, id, peso);
    }

    setState(() {
      loading = false;
    });
  }

  void showEdit() {
    var width = MediaQuery.of(context).size.width;
    var account = Get.find<AccountController>();
    var user = Get.find<AccountController>().user;

    double peso = user!.peso;
    String objetivo = account.user!.objetivo;

    var fields = account.user!.getFormFields();

    Get.dialog(
      Center(
        child: Container(
          width: width,
          height: 368,
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
          child: Material(
            color: bgColorWhiteLight,
            child: Column(
              children: [
                Text(
                  'Editar',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: fontColorBlue,
                    textStyle: const TextStyle(
                      decoration: TextDecoration.none,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: defaultPaddingCardVertical),
                Text(
                  'Deseja editar os dados do seu perfil?',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: fontColorGray,
                    textStyle: const TextStyle(
                      decoration: TextDecoration.none,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: defaultPaddingCardVertical),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Peso (kg):',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: fontColorGray,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: defaultPaddingCardVertical / 2),
                    TextFormField(
                      initialValue: peso.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
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
                        hintText: 'Peso',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: borderRadiusSmall,
                          borderSide: BorderSide(color: bgColorWhiteDark),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: borderRadiusSmall,
                          borderSide: BorderSide(color: bgColorBlueNormal),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: defaultPaddingFieldsVertical,
                            horizontal: defaultPaddingFieldsHorizontal),
                      ),
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty) {
                            peso = double.parse(value);
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: defaultPaddingCardVertical / 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Objetivo:',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: fontColorGray,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: defaultPaddingCardVertical / 2),
                    DropdownButtonFormField(
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
                        hintText: 'Objetivo',
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: borderRadiusSmall,
                          borderSide: BorderSide(color: bgColorWhiteDark),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: borderRadiusSmall,
                          borderSide: BorderSide(color: bgColorBlueNormal),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: defaultPaddingFieldsVertical,
                            horizontal: defaultPaddingFieldsHorizontal),
                      ),
                      items: [
                        for (var option in fields[7]['options'] as List<String>)
                          DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ),
                      ],
                      value:
                          fields[7]['value'] != null && fields[7]['value'] != ''
                              ? fields[7]['value']
                              : null,
                      onChanged: (value) {
                        setState(() {
                          objetivo = value.toString();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: defaultPaddingCardVertical),
                TextButton(
                  onPressed: () => {
                    sendRequest(peso, objetivo),
                    Get.back(),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(statusColorSuccess),
                  ),
                  child: SizedBox(
                    width: width - 2 * defaultPadding,
                    child: Text(
                      'editar',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: fontColorWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: defaultPaddingCardVertical / 2),
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
      ),
      barrierDismissible: false,
    );
  }

  void sendFeedback(String feedback) {
    if (feedback.isNotEmpty) {
      var token = Get.find<AccountController>().token!;

      sendFeedbackEmail(token, feedback).then((value) {
        if (value == 200) {
          Get.back();
        }
      });
    }
  }

  void showFeedback() {
    var width = MediaQuery.of(context).size.width;

    var feedback = '';

    Get.dialog(
      Center(
        child: Container(
          width: width,
          height: 300,
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
          child: Material(
            color: bgColorWhiteLight,
            child: Column(
              children: [
                Text(
                  'Feedback',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: fontColorBlue,
                    textStyle: const TextStyle(
                      decoration: TextDecoration.none,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: defaultPaddingCardVertical),
                Text(
                  'Deseja enviar um feedback sobre o aplicativo?',
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: fontColorGray,
                    textStyle: const TextStyle(
                      decoration: TextDecoration.none,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: defaultPaddingCardVertical),
                TextFormField(
                  initialValue: feedback,
                  keyboardType: TextInputType.text,
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
                    hintText: 'Feedback',
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: borderRadiusSmall,
                      borderSide: BorderSide(color: bgColorWhiteDark),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: borderRadiusSmall,
                      borderSide: BorderSide(color: bgColorBlueNormal),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: defaultPaddingFieldsVertical,
                        horizontal: defaultPaddingFieldsHorizontal),
                  ),
                  onChanged: (value) {
                    setState(() {
                      feedback = value;
                    });
                  },
                  maxLines: 2,
                ),
                const SizedBox(height: defaultPaddingCardVertical),
                TextButton(
                  onPressed: () => {
                    sendFeedback(feedback),
                    Get.back(),
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(statusColorSuccess),
                  ),
                  child: SizedBox(
                    width: width - 2 * defaultPadding,
                    child: Text(
                      'enviar',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: fontColorWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: defaultPaddingCardVertical / 2),
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
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = account.type!;
    final user = account.user;
    final teacher = account.teacher;
    final admin = account.admtech;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var nome = type == 0
        ? user!.nome.toString()
        : type == 1
            ? teacher!.nome.toString()
            : admin!.nome.toString();

    if (nome.length > 10) {
      nome = '${nome.substring(0, 10)}...';
    }

    return MasterPage(
      title: 'perfil',
      showBackButton: false,
      showHeader: false,
      usePadding: false,
      child: SizedBox(
        width: width,
        height: height - 64,
        child: Column(
          children: [
            Container(
              width: width,
              height: height * 0.3,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    bgColorBlueLightSecondary,
                    bgColorBlueNormal,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(defaultRadiusLarger),
                  bottomRight: Radius.circular(defaultRadiusLarger),
                ),
                boxShadow: [boxShadowDefault],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(width: defaultPadding),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nome,
                        style: const TextStyle(
                          color: fontColorWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        type == 0
                            ? 'aluno'
                            : type == 1 &&
                                    teacher != null &&
                                    teacher.isEstagiario
                                ? 'estagiário'
                                : type == 1
                                    ? 'professor'
                                    : 'tec. adm.',
                        style: const TextStyle(
                          color: fontColorWhite,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: fontColorWhite,
                    ),
                    onPressed: () => {
                      account.logout(),
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            type == 0
                ? SizedBox(
                    width: width - (defaultPadding * 2),
                    height: height - (defaultPadding * 2) - 400,
                    child: !loading
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Objetivo: ',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    user!.objetivo,
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding / 2),
                              Row(
                                children: [
                                  Text(
                                    'Altura (cm): ',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${user.altura} cm',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding / 2),
                              Row(
                                children: [
                                  Text(
                                    'Peso (kg): ',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${user.peso} kg',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding / 2),
                              Row(
                                children: [
                                  Text(
                                    'IMC: ',
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    user.imc.toStringAsFixed(2),
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: fontColorGray,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              const SizedBox(height: defaultPadding),
                              SizedBox(
                                width: width - (defaultPadding * 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: fontColorBlue,
                                      ),
                                      onPressed: () => {
                                        showEdit(),
                                      },
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.feedback_outlined,
                                        color: fontColorBlue,
                                      ),
                                      onPressed: () => {
                                        showFeedback(),
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
