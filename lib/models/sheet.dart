import 'package:unifit/models/training.dart';

class Sheet {
  int idficha;
  String nome;
  String tipo;
  String observacoes;
  int series;
  int repeticoes;
  List<Training> treinos;

  Sheet({
    this.idficha = -1,
    this.nome = '',
    this.tipo = '',
    this.treinos = const [],
    this.observacoes = '',
    this.series = -1,
    this.repeticoes = -1,
  });

  factory Sheet.fromJson(Map<String, dynamic> json) {
    return Sheet(
      idficha: json['idficha'],
      nome: json['nome'],
      tipo: json['tipo'],
      treinos: json['treinos'] != null
          ? (json['treinos'] as List).map((i) => Training.fromJson(i)).toList()
          : [],
      observacoes: json['observacoes'] ?? '',
      series: json['series'] ?? -1,
      repeticoes: json['repeticoes'] ?? -1,
    );
  }

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'tipo': tipo,
        'treinos': treinos.map((e) => e.toJson()).toList(),
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
      {
        'atribute': 'tipo',
        'label': 'Tipo',
        'value': tipo,
        'type': 'select',
        'options': ['Iniciante', 'Intermediário', 'Avançado'],
        'required': true,
      },
    ];

    return fields;
  }

  void updateValue(String atribute, dynamic value) {
    switch (atribute) {
      case 'nome':
        nome = value;
        break;
      case 'tipo':
        tipo = value;
        break;
      default:
        break;
    }
  }
}
