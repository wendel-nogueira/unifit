verifyAbirthDateFormat(String birthDate) {
  List<String> date =
      birthDate.toString().substring(0, 10).split('-').reversed.toList();

  String birthDateFormated = '${date[1]}/${date[0]}/${date[2]}';

  return birthDateFormated;
}
