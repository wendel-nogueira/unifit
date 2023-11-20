import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/models/exercise.dart';
import 'package:unifit/services/create_carga.dart';
import 'package:unifit/services/get_sheet.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:unifit/services/get_student_sheets.dart';
import 'package:unifit/utils/alert.dart';

import '../../components/page.dart';
import '../../constants.dart';
import '../../controllers/account_controller.dart';
import '../../models/sheet.dart';
import '../../services/get_student_load.dart';

class ViewSheetScreen extends StatefulWidget {
  const ViewSheetScreen({super.key});

  @override
  State<ViewSheetScreen> createState() => _ViewSheetScreen();
}

class _ViewSheetScreen extends State<ViewSheetScreen> {
  Sheet? sheet;
  int sheetId = -1;
  bool loading = true;
  Map<String, dynamic> training = {};
  int indexPage = 0;
  final GlobalKey<_TrainingNameTextState> _trainingNameTextKey =
      GlobalKey<_TrainingNameTextState>();

  List<dynamic> loans = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      getInfo();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getInfo() {
    setState(
      () {
        var queryParams = Get.parameters;

        if (queryParams['id'] != null) {
          sheetId = int.parse(queryParams['id']!);
        }

        var accountController = Get.find<AccountController>();

        String token = accountController.token!;

        getSheet(token, sheetId).then(
          (value) => {
            if (mounted)
              setState(
                () {
                  if (sheetId != -1) {
                    sheet = value;
                    loading = false;
                  }
                },
              )
          },
        );

        var type = accountController.type;

        if (type == 0) {
          var studentId = accountController.user!.idAluno;

          setState(() {
            loading = true;
          });

          getStudentSheets(token, studentId).then(
            (value) => {
              if (mounted)
                setState(
                  () {
                    if (sheetId != -1) {
                      var selectedSheet = value
                          .firstWhere((element) => element.idficha == sheetId);

                      sheet = selectedSheet;

                      getStudentLoad(token, studentId).then(
                        (value) => {
                          setState(
                            () {
                              loans = value;

                              for (var element in sheet!.treinos) {
                                for (var exercise in element.exercicios) {
                                  var loan = loans.firstWhere(
                                      (element) =>
                                          element['exercicio_idexercicio'] ==
                                          exercise.idexercicio,
                                      orElse: () => null);

                                  if (loan != null && loan['carga'] != null) {
                                    exercise.peso = loan['carga'].toDouble();
                                  }
                                }
                              }

                              loading = false;
                            },
                          )
                        },
                      );
                    }
                  },
                )
            },
          );
        }
      },
    );
  }

  void showExercise(String name, String dica, String path) {
    var width = MediaQuery.of(context).size.width;
    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    var heightDialog = 160.0;

    if (path != '') {
      heightDialog += 160;
    } else {
      heightDialog += 10;
    }

    var lines = (dica.length / 40).ceil();
    heightDialog += lines * 24;

    Get.dialog(
      Center(
        child: Container(
          width: width,
          height: heightDialog,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: defaultPadding,
            bottom: defaultPadding,
          ),
          decoration: const BoxDecoration(
            color: bgColorWhiteLight,
            borderRadius: borderRadiusSmall,
            boxShadow: [boxShadowDefault],
          ),
          child: Column(
            children: [
              Text(
                name,
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
                dica,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: fontColorGray,
                  textStyle: const TextStyle(
                    decoration: TextDecoration.none,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: defaultPaddingCardVertical),
              path != ''
                  ? Container(
                      width: 140,
                      height: 140,
                      decoration: const BoxDecoration(
                        color: bgColorWhiteNormal,
                        borderRadius: BorderRadius.all(
                          Radius.circular(defaultRadiusSmall),
                        ),
                        boxShadow: [boxShadowDefault],
                      ),
                      child: Image.network(
                        path,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return const Icon(Icons.close_rounded);
                        },
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: defaultPaddingCardVertical),
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
      barrierDismissible: false,
    );
  }

  int calculate1RM(int peso, int repeticoes, String nome) {
    var accountController = Get.find<AccountController>();
    var objetivo = accountController.user!.objetivo.toLowerCase();
    var objetivos = [
      'força pura',
      'força',
      'hipertrofia',
      'resistência',
      'perda de peso'
    ];

    if (!objetivos.contains(objetivo)) {
      showAlert(
        'erro',
        'erro ao calcular a carga máxima, verifique o seu objetivo!',
        'error',
      );

      return 0;
    }

    double coeficiente = 0;

    switch (objetivo) {
      case 'força pura':
        coeficiente = 0.94;
        break;
      case 'força':
        coeficiente = 0.86;
        break;
      case 'hipertrofia':
        coeficiente = 0.76;
        break;
      case 'resistência':
        coeficiente = 0.68;
        break;
      case 'perda de peso':
        coeficiente = 0.60;
        break;
      default:
        coeficiente = 0;
        break;
    }

    int result = peso * (1 + (0.0333 * repeticoes * coeficiente)).round();
    Exercise? exercise;

    for (var element in sheet!.treinos) {
      if (element.exercicios.any((element) => element.nome == nome)) {
        exercise =
            element.exercicios.firstWhere((element) => element.nome == nome);
      }
    }

    var token = accountController.token!;
    var studentId = accountController.user!.idAluno;

    if (exercise != null) {
      createCarga(token, studentId, exercise.idexercicio, result);
    }

    return result;
  }

  void calculate(String name, _CardContent cardContent) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    int peso = 0;
    int repeticoes = 0;

    Get.dialog(
      Center(
        child: Container(
          width: width,
          height: height - 280,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: defaultPadding,
            bottom: defaultPadding,
          ),
          decoration: const BoxDecoration(
            color: bgColorWhiteLight,
            borderRadius: borderRadiusSmall,
            boxShadow: [boxShadowDefault],
          ),
          child: Column(
            children: [
              Text(
                name,
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
                'informe os campos abaixo para calcular a sua carga máxima!',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: fontColorGray,
                  textStyle: const TextStyle(
                    decoration: TextDecoration.none,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: defaultPaddingCardVertical),
              SizedBox(
                width: width - 2 * defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'carga atual (kg)',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: fontColorGray,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: defaultMarginSmall),
                    Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        initialValue: peso.toString(),
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.manrope(
                          color: fontColorGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true,
                          hintStyle: GoogleFonts.manrope(
                            color: fontColorGray,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.none,
                          ),
                          filled: true,
                          fillColor: bgColorWhiteLight,
                          hintText: 'informe a carga atual (kg)',
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
                          if (value != '') peso = int.parse(value);
                        },
                      ),
                    ),
                    const SizedBox(height: defaultPaddingCardVertical),
                    Text(
                      'repetições',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: fontColorGray,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: defaultMarginSmall),
                    Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        initialValue: repeticoes.toString(),
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.manrope(
                          color: fontColorGray,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        inputFormatters: [
                          // only numbers
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+')),
                        ],
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          isDense: true,
                          hintStyle: GoogleFonts.manrope(
                            color: fontColorGray,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: bgColorWhiteLight,
                          hintText: 'informe as repetições',
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
                          if (value != '') repeticoes = int.parse(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultMarginSmall),
              TextButton(
                onPressed: () => {
                  setState(() {
                    for (var element in sheet!.treinos) {
                      if (element.exercicios
                          .any((element) => element.nome == name)) {
                        element.exercicios
                                .firstWhere((element) => element.nome == name)
                                .peso =
                            double.parse(calculate1RM(peso, repeticoes, name)
                                .toStringAsFixed(2));
                      }
                    }

                    cardContent.updatePeso(double.parse(
                        calculate1RM(peso, repeticoes, name)
                            .toStringAsFixed(2)));

                    Get.back();
                  })
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(statusColorInfo),
                ),
                child: SizedBox(
                  width: width - 2 * defaultPadding,
                  child: Text(
                    'calcular',
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
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var controller = SwiperController();

    var accountController = Get.find<AccountController>();
    var type = accountController.type;

    return MasterPage(
      title: 'ficha #${sheetId.toString()}',
      showMenu: false,
      child: Column(
        children: [
          Container(
            width: width - 2 * defaultPadding,
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
            child: !loading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'nome: ${sheet != null ? sheet!.nome : 'erro'}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: fontColorGray,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'tipo: ${sheet != null ? sheet!.tipo : 'erro'}',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: fontColorGray,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Container(
            width: width - 2 * defaultPadding,
            margin: const EdgeInsets.only(bottom: defaultPadding / 2),
            child: const Divider(
              color: bgColorWhiteDark,
              height: 1,
              thickness: 1,
            ),
          ),
          const SizedBox(height: defaultPadding),
          !loading
              ? SizedBox(
                  width: width - 2 * defaultPadding,
                  height: height - 310, // fixed height
                  child: ListView.builder(
                    itemCount: sheet != null ? sheet!.treinos.length : 0,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: bgColorWhiteNormal,
                              borderRadius: BorderRadius.all(
                                Radius.circular(defaultRadiusSmall),
                              ),
                              boxShadow: [boxShadowDefault],
                            ),
                            margin: const EdgeInsets.only(
                                bottom: defaultPadding / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPaddingCardHorizontal,
                                      vertical: defaultPaddingCardVertical),
                                  child: Text(
                                    'treino #${sheet != null ? sheet!.treinos[index].nome : 'erro'}',
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
                                    setState(
                                      () {
                                        training = {};

                                        var exercises =
                                            sheet!.treinos[index].exercicios;

                                        for (var i = 0;
                                            i < exercises.length;
                                            i++) {
                                          if (training[exercises[i]
                                                  .regiaoCorporea] ==
                                              null) {
                                            training[exercises[i]
                                                .regiaoCorporea] = [];
                                          }

                                          training[exercises[i].regiaoCorporea]
                                              .add(exercises[i].nome);
                                        }
                                      },
                                    ),
                                    Get.dialog(
                                      Center(
                                        child: Container(
                                          width: width,
                                          height: height - 50,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(
                                            top: defaultPadding,
                                            bottom: defaultPadding,
                                          ),
                                          decoration: const BoxDecoration(
                                            color: bgColorWhiteLight,
                                            borderRadius: borderRadiusSmall,
                                            boxShadow: [boxShadowDefault],
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 2),
                                              Text(
                                                'treino #${sheet != null ? sheet!.treinos[index].nome : 'erro'}',
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: fontColorBlue,
                                                  textStyle: const TextStyle(
                                                    decoration:
                                                        TextDecoration.none,
                                                  ),
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(
                                                  height: defaultPadding),
                                              SizedBox(
                                                width:
                                                    width - 2 * defaultPadding,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    training.length > 1
                                                        ? Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              onTap: () => {
                                                                setState(() {
                                                                  controller
                                                                      .previous();
                                                                }),
                                                              },
                                                              child: const Icon(
                                                                Icons
                                                                    .arrow_back_ios_outlined,
                                                                color:
                                                                    fontColorBlue,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                    TrainingNameText(
                                                      key: _trainingNameTextKey,
                                                      text: training.keys
                                                          .elementAt(0),
                                                    ),
                                                    training.length > 1
                                                        ? Material(
                                                            color: Colors
                                                                .transparent,
                                                            child: InkWell(
                                                              onTap: () => {
                                                                setState(() {
                                                                  controller
                                                                      .next();
                                                                }),
                                                              },
                                                              child: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_outlined,
                                                                color:
                                                                    fontColorBlue,
                                                                size: 18,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: defaultPadding),
                                              // swipper
                                              SizedBox(
                                                width: width,
                                                height: height - 246,
                                                child: Swiper(
                                                  itemBuilder:
                                                      (context, indexCol) {
                                                    return Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          width: width -
                                                              2 * defaultPadding,
                                                          height: height -
                                                              246, // fixed height
                                                          child:
                                                              ListView.builder(
                                                            itemCount: training[
                                                                    training
                                                                        .keys
                                                                        .elementAt(
                                                                            indexCol)]
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    indexCol2) {
                                                              final GlobalKey<
                                                                      _CardContent>
                                                                  exerciseCart =
                                                                  GlobalKey<
                                                                      _CardContent>();

                                                              return Column(
                                                                children: [
                                                                  Material(
                                                                    color: Colors
                                                                        .transparent,
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        showExercise(
                                                                            sheet!.treinos[index].exercicios.firstWhere((element) => element.nome == training[training.keys.elementAt(indexCol)][indexCol2]).nome,
                                                                            sheet!.treinos[index].exercicios.firstWhere((element) => element.nome == training[training.keys.elementAt(indexCol)][indexCol2]).dica,
                                                                            sheet!.treinos[index].exercicios.firstWhere((element) => element.nome == training[training.keys.elementAt(indexCol)][indexCol2]).imagepath),
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              bgColorWhiteNormal,
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(defaultRadiusSmall),
                                                                          ),
                                                                          boxShadow: [
                                                                            boxShadowDefault
                                                                          ],
                                                                        ),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              width,
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: defaultPaddingCardHorizontal,
                                                                              vertical: defaultPaddingCardVertical),
                                                                          child: type == 1
                                                                              ? Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Text(
                                                                                      training[training.keys.elementAt(indexCol)][indexCol2],
                                                                                      style: GoogleFonts.manrope(
                                                                                        fontWeight: FontWeight.normal,
                                                                                        fontSize: 14,
                                                                                        color: fontColorGray,
                                                                                        decoration: TextDecoration.none,
                                                                                      ),
                                                                                      textAlign: TextAlign.left,
                                                                                    ),
                                                                                    const Icon(
                                                                                      Icons.info_outline_rounded,
                                                                                      color: fontColorBlue,
                                                                                      size: 16,
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              : Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          training[training.keys.elementAt(indexCol)][indexCol2],
                                                                                          style: GoogleFonts.manrope(
                                                                                            fontWeight: FontWeight.bold,
                                                                                            fontSize: 14,
                                                                                            color: fontColorGray,
                                                                                            decoration: TextDecoration.none,
                                                                                          ),
                                                                                        ),
                                                                                        const Icon(
                                                                                          Icons.info_outline_rounded,
                                                                                          color: fontColorBlue,
                                                                                          size: 16,
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    const SizedBox(height: 12),
                                                                                    CardContent(series: sheet!.series, repeticoes: sheet!.repeticoes, observacoes: sheet!.observacoes, peso: sheet!.treinos[index].exercicios.firstWhere((element) => element.nome == training[training.keys.elementAt(indexCol)][indexCol2]).peso, key: exerciseCart),
                                                                                    const SizedBox(height: 12),
                                                                                    InkWell(
                                                                                      onTap: () => {
                                                                                        calculate(sheet!.treinos[index].exercicios.firstWhere((element) => element.nome == training[training.keys.elementAt(indexCol)][indexCol2]).nome, exerciseCart.currentState!),
                                                                                      },
                                                                                      child: Text(
                                                                                        'calcular carga máxima',
                                                                                        style: GoogleFonts.manrope(
                                                                                          fontWeight: FontWeight.w400,
                                                                                          fontSize: 16,
                                                                                          color: fontColorBlue,
                                                                                          decoration: TextDecoration.none,
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          12),
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                  autoplay: false,
                                                  itemCount: training.length,
                                                  index: 0,
                                                  controller: controller,
                                                  loop: training.length > 1
                                                      ? true
                                                      : false,
                                                  onIndexChanged: (index) {
                                                    setState(
                                                      () {
                                                        _trainingNameTextKey
                                                            .currentState!
                                                            .updateText(training
                                                                .keys
                                                                .elementAt(
                                                                    index));
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
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
                                                  width: width -
                                                      2 * defaultPadding,
                                                  child: Text(
                                                    'fechar',
                                                    style: GoogleFonts.roboto(
                                                      fontWeight:
                                                          FontWeight.w500,
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
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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

class TrainingNameText extends StatefulWidget {
  TrainingNameText({super.key, required this.text});

  String text;

  @override
  State<TrainingNameText> createState() => _TrainingNameTextState();
}

class _TrainingNameTextState extends State<TrainingNameText> {
  @override
  void initState() {
    super.initState();
  }

  void updateText(String newText) {
    setState(() {
      widget.text = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: GoogleFonts.manrope(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: fontColorBlue,
        textStyle: const TextStyle(
          decoration: TextDecoration.none,
        ),
      ),
      textAlign: TextAlign.center,
    );
  }
}

class CardContent extends StatefulWidget {
  CardContent(
      {super.key,
      required this.series,
      required this.repeticoes,
      required this.observacoes,
      required this.peso});

  int series;
  int repeticoes;
  String observacoes;
  double peso;

  @override
  State<CardContent> createState() => _CardContent();
}

class _CardContent extends State<CardContent> {
  @override
  void initState() {
    super.initState();
  }

  void updatePeso(double newPeso) {
    setState(() {
      widget.peso = newPeso;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'séries: ${widget.series == -1 ? 'n/i' : widget.series}',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: fontColorGray,
          decoration: TextDecoration.none,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'repetições:  ${widget.repeticoes == -1 ? 'n/i' : widget.repeticoes}',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: fontColorGray,
          decoration: TextDecoration.none,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'carga máxima (aprox): ${widget.peso}kg',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: fontColorGray,
          decoration: TextDecoration.none,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'observações: ${widget.observacoes}',
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: fontColorGray,
          decoration: TextDecoration.none,
        ),
      ),
      const SizedBox(height: 6),
    ]);
  }
}
