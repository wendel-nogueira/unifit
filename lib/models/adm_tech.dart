class AdmTech {
  int idTecnicoAdministrativo;
  String nome;
  String sexo;
  String email;
  DateTime? nascimento;
  String? senha;

  AdmTech({
    this.idTecnicoAdministrativo = -1,
    this.nome = '',
    this.email = '',
    this.sexo = '',
    this.nascimento,
    this.senha,
  });

  factory AdmTech.fromJson(Map<String, dynamic> json) {
    return AdmTech(
      idTecnicoAdministrativo: json['idtecnico_administrativo'] ?? -1,
      nome: json['nome'],
      email: json['email'],
      sexo: json['sexo'] ?? '',
      nascimento: DateTime.parse(json['nascimento']),
      senha: json['senha'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'idtecnicoadministrativo': idTecnicoAdministrativo,
        'nome': nome,
        'email': email,
        'sexo': sexo,
        'nascimento': nascimento!.toIso8601String(),
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
        'edit': true,
      },
      {
        'atribute': 'email',
        'label': 'E-mail',
        'type': 'email',
        'length': 45,
        'required': true,
        'value': email,
        'edit': true,
      },
      {
        'atribute': 'senha',
        'label': 'Senha',
        'type': 'password',
        'length': 45,
        'required': true,
        'value': senha,
        'edit': false,
      },
      {
        'atribute': 'nascimento',
        'label': 'Data de nascimento',
        'type': 'date',
        'required': true,
        'value': nascimento,
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
      default:
        break;
    }
  }
}
