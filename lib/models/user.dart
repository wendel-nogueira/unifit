class User {
  int idAluno;
  String matricula;
  String nome;
  String email;
  String curso;
  DateTime nascimento;
  String objetivo;
  int anoIngresso;
  String etnia;
  String sexo;
  String observacao;

  User({
    required this.idAluno,
    required this.matricula,
    required this.nome,
    required this.email,
    required this.curso,
    required this.nascimento,
    required this.objetivo,
    required this.anoIngresso,
    required this.etnia,
    required this.sexo,
    required this.observacao,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idAluno: json['idAluno'],
      matricula: json['matricula'],
      nome: json['nome'],
      email: json['email'],
      curso: json['curso'],
      nascimento: json['nascimento'],
      objetivo: json['objetivo'],
      anoIngresso: json['anoIngresso'],
      etnia: json['etnia'],
      sexo: json['sexo'],
      observacao: json['observacao'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idAluno': idAluno,
        'matricula': matricula,
        'nome': nome,
        'email': email,
        'curso': curso,
        'nascimento': nascimento,
        'objetivo': objetivo,
        'anoIngresso': anoIngresso,
        'etnia': etnia,
        'sexo': sexo,
        'observacao': observacao,
      };
}
