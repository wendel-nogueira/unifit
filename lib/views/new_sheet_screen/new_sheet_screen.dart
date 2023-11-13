import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unifit/models/exercise.dart';
import 'package:unifit/models/training.dart';
import 'package:unifit/utils/alert.dart';

import '../../components/page.dart';
import '../../constants.dart';
import '../../controllers/account_controller.dart';
import '../../models/sheet.dart';
import '../../services/create_sheet.dart';
import '../../utils/exercises_list.dart';

class NewSheetScreen extends StatefulWidget {
  const NewSheetScreen({super.key});

  @override
  State<NewSheetScreen> createState() => _NewSheetScreen();
}

class _NewSheetScreen extends State<NewSheetScreen> {
  Sheet sheet = Sheet();
  bool loading = false;
  var accountController = Get.find<AccountController>();

  List<Training> trainings = [];
  int countTrainings = 0;

  final GlobalKey<_TrainingNameTextState> _trainingNameTextKey =
      GlobalKey<_TrainingNameTextState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool validateForm() {
    var fields = sheet.getFormFields();

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
    var width = MediaQuery.of(context).size.width;
    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    if (validateForm() && !loading) {
      if (trainings.isEmpty) {
        showAlert(
          'erro',
          'adicione pelo menos um treino!',
          'error',
        );

        return;
      }

      sheet.treinos = trainings;

      setState(() {
        loading = true;
      });

      var token = accountController.token as String;

      createSheet(token, sheet).then((value) {
        setState(() {
          loading = false;

          if (value == 200 || value == 201) {
            Get.toNamed('/sheets-list');
          }
        });
      }).catchError((error) {
        setState(() {
          loading = false;
        });
      });
    }
  }

  void createTraining() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var dialogSize = width - 2 * defaultPadding;

    if (dialogSize > 380) {
      dialogSize = 380;
    }

    Training training = Training();
    var controller = SwiperController();
    Map<String, dynamic> exercises = {};
    List<int> exercisesListToAdd = [];

    for (var exercise in exercisesList) {
      if (exercises[exercise["regiao_corporea"]] == null) {
        exercises[exercise["regiao_corporea"].toString()] = [];
      }

      exercises[exercise["regiao_corporea"].toString()].add({
        "id": exercise["idexercicio"],
        "nome": exercise["nome"],
      });
    }

    var alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

    Get.dialog(
      Center(
        child: Container(
          width: width,
          height: height - 50,
          alignment: Alignment.topLeft,
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
                alphabet.length > countTrainings
                    ? 'treino #${alphabet[countTrainings].toUpperCase()}'
                    : 'treino #${alphabet[alphabet.length - countTrainings].toUpperCase()}$countTrainings',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: fontColorBlue,
                  textStyle: const TextStyle(
                    decoration: TextDecoration.none,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: defaultPaddingCardVertical),
              SizedBox(
                width: width - 2 * defaultPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    exercises.length > 1
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => {
                                setState(() {
                                  controller.previous();
                                }),
                              },
                              child: const Icon(
                                Icons.arrow_back_ios_outlined,
                                color: fontColorBlue,
                                size: 18,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    TrainingNameText(
                      key: _trainingNameTextKey,
                      text: exercises.keys.elementAt(0),
                    ),
                    exercises.length > 1
                        ? Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => {
                                setState(() {
                                  controller.next();
                                }),
                              },
                              child: const Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: fontColorBlue,
                                size: 18,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              // swipper
              SizedBox(
                width: width,
                height: height - 280,
                child: Swiper(
                  itemBuilder: (context, indexCol) {
                    return Column(
                      children: <Widget>[
                        SizedBox(
                          width: width - 2 * defaultPadding,
                          height: height - 300, // fixed height
                          child: ListView.builder(
                            itemCount:
                                exercises[exercises.keys.elementAt(indexCol)]
                                    .length,
                            itemBuilder: (context, indexCol2) {
                              final GlobalKey<_ExerciseRow> exerciseRowKey =
                                  GlobalKey<_ExerciseRow>();

                              return Column(
                                children: [
                                  ExerciseRow(
                                    text: exercises[exercises.keys
                                                .elementAt(indexCol)][indexCol2]
                                            ["nome"]
                                        .toString(),
                                    color: exercisesListToAdd.contains(
                                            exercises[exercises.keys
                                                    .elementAt(indexCol)]
                                                [indexCol2]["id"])
                                        ? statusColorError
                                        : statusColorInfo,
                                    icon: Icon(
                                      exercisesListToAdd.contains(exercises[
                                                  exercises.keys
                                                      .elementAt(indexCol)]
                                              [indexCol2]["id"])
                                          ? Icons.close_outlined
                                          : Icons.add_outlined,
                                      color: fontColorWhite,
                                      size: 18,
                                    ),
                                    key: exerciseRowKey,
                                    onTap: () => {
                                      setState(() {
                                        if (exercisesListToAdd.contains(
                                            exercises[exercises.keys
                                                    .elementAt(indexCol)]
                                                [indexCol2]["id"])) {
                                          exercisesListToAdd.remove(exercises[
                                                  exercises.keys
                                                      .elementAt(indexCol)]
                                              [indexCol2]["id"]);

                                          exerciseRowKey.currentState!
                                              .updateStatus(
                                            statusColorInfo,
                                            const Icon(
                                              Icons.add_outlined,
                                              color: fontColorWhite,
                                              size: 18,
                                            ),
                                          );
                                        } else {
                                          exercisesListToAdd.add(exercises[
                                              exercises.keys.elementAt(
                                                  indexCol)][indexCol2]["id"]);

                                          exerciseRowKey.currentState!
                                              .updateStatus(
                                            statusColorError,
                                            const Icon(
                                              Icons.close_outlined,
                                              color: fontColorWhite,
                                              size: 18,
                                            ),
                                          );
                                        }
                                      }),
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  autoplay: false,
                  itemCount: exercises.length,
                  index: 0,
                  controller: controller,
                  loop: exercises.length > 1 ? true : false,
                  onIndexChanged: (index) {
                    setState(
                      () {
                        _trainingNameTextKey.currentState!
                            .updateText(exercises.keys.elementAt(index));
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () => {
                  if (exercisesListToAdd.isNotEmpty)
                    {
                      setState(() {
                        training.exercicios = exercisesList
                            .where((element) => exercisesListToAdd
                                .contains(element["idexercicio"]))
                            .map((e) => Exercise(
                                  idexercicio: e["idexercicio"] as int,
                                  nome: e["nome"] as String,
                                  regiaoCorporea:
                                      e["regiao_corporea"] as String,
                                ))
                            .toList();

                        training.idtreino = countTrainings;
                        training.nome = alphabet.length > countTrainings
                            ? 'treino #${alphabet[countTrainings].toUpperCase()}'
                            : 'treino #${alphabet[alphabet.length - countTrainings].toUpperCase()}$countTrainings';

                        trainings.add(training);

                        countTrainings += 1;

                        exercisesListToAdd = [];
                        Get.back();
                      }),
                    }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(statusColorSuccess),
                ),
                child: SizedBox(
                  width: width - 2 * defaultPadding,
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var fields = sheet.getFormFields();

    return MasterPage(
        title: 'nova ficha',
        showMenu: false,
        child: SizedBox(
          width: width - 2 * defaultPadding,
          height: height - 80,
          child: Column(
            children: [
              Container(
                width: double.infinity,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: <Widget>[
                        SizedBox(
                          height: height - (height * 0.59),
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
                                          onChanged: (value) {
                                            setState(() {
                                              sheet.updateValue(
                                                  fields[index]['atribute'],
                                                  value);
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
                                          onChanged: (value) {
                                            setState(() {
                                              sheet.updateValue(
                                                  fields[index]['atribute'],
                                                  value);
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
                                            MaterialStateProperty.all<Color>(
                                                loading
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
                                        if (!loading) createTraining(),
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                loading
                                                    ? bgColorGray
                                                    : statusColorInfo),
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          loading
                                              ? 'salvando...'
                                              : 'adicionar treino',
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
                    ),
                  ],
                ),
              ),
              SizedBox(
                height:
                    height - (height * 0.6) - defaultPadding, // fixed height
                child: ListView.builder(
                  itemCount: trainings.length,
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
                          margin:
                              const EdgeInsets.only(bottom: defaultPadding / 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPaddingCardHorizontal,
                                    vertical: defaultPaddingCardVertical),
                                child: Text(
                                  trainings[index].nome!,
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
                                    color: statusColorError,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(defaultRadiusSmall),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.close_outlined,
                                    color: fontColorWhite,
                                    size: 18,
                                  ),
                                ),
                                onTap: () => {
                                  setState(
                                    () {
                                      trainings.removeAt(index);
                                    },
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
            ],
          ),
        ));
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

class ExerciseRow extends StatefulWidget {
  ExerciseRow(
      {super.key,
      required this.text,
      required this.color,
      required this.icon,
      required this.onTap});

  String text;
  Color color;
  Icon icon;
  Function onTap;

  @override
  State<ExerciseRow> createState() => _ExerciseRow();
}

class _ExerciseRow extends State<ExerciseRow> {
  @override
  void initState() {
    super.initState();
  }

  void updateStatus(Color newColor, Icon newIcon) {
    setState(() {
      widget.color = newColor;
      widget.icon = newIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              widget.text,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: fontColorGray,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Material(
            child: InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPaddingCardVertical,
                      vertical: defaultPaddingCardVertical),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(defaultRadiusSmall),
                    ),
                  ),
                  child: widget.icon,
                ),
                onTap: () => {
                      widget.onTap(),
                    }),
          ),
        ],
      ),
    );
  }
}
