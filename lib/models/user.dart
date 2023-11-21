import 'package:unifit/models/anamnesis.dart';
import 'package:unifit/models/assessment.dart';

class User {
  int idAluno;
  String matricula;
  String nome;
  String email;
  String curso;
  DateTime? nascimento;
  String objetivo;
  int anoIngresso;
  String etnia;
  String sexo;
  String? observacao;
  String? senha;
  double imc;
  double peso;
  int altura;
  List<Assessment> assessments = [];
  Anamnesis anamnesis = Anamnesis();

  User({
    this.idAluno = -1,
    this.matricula = '',
    this.nome = '',
    this.email = '',
    this.curso = '',
    this.nascimento,
    this.objetivo = '',
    this.anoIngresso = 0,
    this.etnia = '',
    this.sexo = '',
    this.observacao = '',
    this.senha,
    this.imc = 0,
    this.peso = 0,
    this.altura = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idAluno: json.containsKey('idaluno') ? json['idaluno'] : -1,
      matricula: json['matricula'],
      nome: json['nome'],
      email: json['email'],
      curso: json['curso'],
      nascimento: DateTime.parse(json['nascimento']),
      objetivo: json['objetivo'] ?? '',
      anoIngresso: json['ano_ingresso'] ?? 0,
      etnia: json['etnia'] ?? '',
      sexo: json['sexo'] ?? '',
      observacao: json['observacao'] ?? '',
      senha: json['senha'] ?? '',
      imc: json['imc'] != null
          ? json['imc'].runtimeType == String
              ? double.parse(json['imc'])
              : json['imc'] ?? 0
          : 0,
      peso: json['peso'] != null
          ? json['peso'].runtimeType == String
              ? double.parse(json['peso'])
              : json['peso'] ?? 0
          : 0,
      altura: json['altura'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'idaluno': idAluno,
        'matricula': matricula,
        'nome': nome,
        'email': email,
        'curso': curso,
        'nascimento': nascimento!.toIso8601String(),
        'objetivo': objetivo,
        'ano_ingresso': anoIngresso,
        'etnia': etnia,
        'sexo': sexo,
        'observacao': observacao,
        'senha': senha ?? '',
        'imc': imc,
        'peso': peso,
        'altura': altura,
      };

  List<dynamic> getFormFields() {
    List<dynamic> fields = [
      {
        'atribute': 'matricula',
        'label': 'Matrícula',
        'value': matricula,
        'type': 'text',
        'length': 45,
        'edit': false,
      },
      {
        'atribute': 'nome',
        'label': 'Nome',
        'value': nome,
        'type': 'text',
        'length': 45,
        'edit': false,
      },
      {
        'atribute': 'email',
        'label': 'E-mail',
        'value': email,
        'type': 'email',
        'length': 45,
        'edit': false,
      },
      {
        'atribute': 'senha',
        'label': 'Senha',
        'value': senha,
        'type': 'password',
        'length': 45,
        'edit': false,
      },
      {
        'atribute': 'curso',
        'label': 'Curso',
        'value': curso,
        'type': 'select',
        'options': [
          'ADM',
          'CCO',
          'CAT',
          'CBL',
          'EAM',
          'ECI',
          'EBP',
          'ECO',
          'ECA',
          'EEN',
          'EMA',
          'EPR',
          'EEL',
          'EEE',
          'EHI',
          'EME',
          'EMA',
          'EQI',
          'FIB',
          'FIL',
          'MBA',
          'MLI',
          'QBA',
          'QLI',
          'SIN'
        ],
        'required': true,
        'edit': true,
      },
      {
        'atribute': 'nascimento',
        'label': 'Data de Nascimento',
        'value': nascimento,
        'type': 'date',
        'required': true,
        'edit': false,
      },
      {
        'atribute': 'anoIngresso',
        'label': 'Ano de Ingresso',
        'value': anoIngresso,
        'type': 'select',
        'options': [
          for (int i = 2000; i <= DateTime.now().year; i++) i.toString()
        ],
        'required': true,
        'edit': false,
      },
      {
        'atribute': 'objetivo',
        'label': 'Objetivo',
        'value': objetivo,
        'type': 'select',
        'options': [
          'Emagrecimento',
          'Hipertrofia',
          'Força',
          'Resistência',
        ],
        'required': true,
        'edit': true,
      },
      {
        'atribute': 'etnia',
        'label': 'Etnia',
        'value': etnia,
        'type': 'select',
        'options': ['Branco', 'Negro', 'Oriental', 'Hispania', 'Pardo'],
        'required': true,
        'edit': false,
      },
      {
        'atribute': 'sexo',
        'label': 'Sexo',
        'value': sexo,
        'type': 'select',
        'options': [
          'Masculino',
          'Feminino',
        ],
        'edit': false,
      },
      {
        'atribute': 'observacao',
        'label': 'Observação',
        'value': observacao,
        'type': 'text',
        'length': 45,
        'edit': true,
      }
    ];

    return fields;
  }

  void updateValue(String atribute, dynamic value) {
    switch (atribute) {
      case 'matricula':
        matricula = value;
        break;
      case 'nome':
        nome = value;
        break;
      case 'email':
        email = value;
        break;
      case 'senha':
        senha = value;
        break;
      case 'curso':
        curso = value;
        break;
      case 'nascimento':
        nascimento = value;
        break;
      case 'objetivo':
        objetivo = value;
        break;
      case 'anoIngresso':
        anoIngresso = value;
        break;
      case 'etnia':
        etnia = value;
        break;
      case 'sexo':
        sexo = value;
        break;
      case 'observacao':
        observacao = value;
        break;
      default:
        break;
    }
  }
}
