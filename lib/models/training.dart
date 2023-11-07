import 'exercise.dart';

class Training {
  int idtreino;
  String? nome;
  List<Exercise> exercicios;

  Training({
    this.idtreino = -1,
    this.nome,
    this.exercicios = const [],
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      idtreino: json['idtreino'],
      nome: json['nome'],
      exercicios: json['exercicios'] != null
          ? (json['exercicios'] as List)
              .map((i) => Exercise.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'exercicios': exercicios.map((e) => e.toJson()).toList(),
      };

  List<dynamic> getFormFields() {
    List<dynamic> fields = [
      {
        'atribute': 'nome',
        'label': 'Nome',
        'value': nome,
        'type': 'text',
        'length': 45,
      },
    ];

    return fields;
  }

  void updateValue(String atribute, dynamic value) {
    switch (atribute) {
      case 'nome':
        nome = value;
        break;
      default:
        break;
    }
  }
}
