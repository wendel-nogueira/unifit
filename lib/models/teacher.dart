class Teacher {
  int idProfessor;
  String nome;
  String email;
  DateTime? nascimento;
  String sexo;
  bool isEstagiario;
  String? senha;

  Teacher({
    this.idProfessor = -1,
    this.nome = '',
    this.email = '',
    this.nascimento,
    this.sexo = '',
    this.isEstagiario = false,
    this.senha,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      idProfessor: json['idprofessor'] ?? json['idProfessor'] ?? -1,
      nome: json['nome'],
      email: json['email'],
      nascimento: DateTime.parse(json['nascimento']),
      sexo: json['sexo'] ?? '',
      isEstagiario: json['isestagiario'] == 'true' ? true : false,
      senha: json['senha'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'idprofessor': idProfessor,
        'nome': nome,
        'email': email,
        'nascimento': nascimento!.toIso8601String(),
        'sexo': sexo,
        'isestagiario': isEstagiario.toString(),
        'senha': senha ?? '',
      };

  List<dynamic> getFormFields() {
    List<dynamic> fields = [
      {
        'atribute': 'nome',
        'label': 'Nome',
        'type': 'text',
        'length': 45,
        'required': true,
        'value': nome,
      },
      {
        'atribute': 'email',
        'label': 'E-mail',
        'type': 'email',
        'length': 45,
        'required': true,
        'value': email,
      },
      {
        'atribute': 'senha',
        'label': 'Senha',
        'type': 'password',
        'length': 45,
        'required': true,
        'value': senha,
      },
      {
        'atribute': 'nascimento',
        'label': 'Data de nascimento',
        'type': 'date',
        'required': true,
        'value': nascimento,
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
      },
      {
        'atribute': 'isEstagiario',
        'label': 'É estagiário?',
        'value': isEstagiario,
        'type': 'checkbox',
      },
    ];

    return fields;
  }

  void updateValue(String atribute, dynamic value) {
    switch (atribute) {
      case 'nome':
        nome = value;
        break;
      case 'email':
        email = value;
        break;
      case 'senha':
        senha = value;
        break;
      case 'nascimento':
        nascimento = value;
        break;
      case 'sexo':
        sexo = value;
        break;
      case 'isEstagiario':
        isEstagiario = value;
        break;
      default:
        break;
    }
  }
}
