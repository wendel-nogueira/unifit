class AdmTech {
  int idTecnicoAdministrativo;
  String nome;
  String sexo;
  String email;
  DateTime nascimento;

  AdmTech({
    required this.idTecnicoAdministrativo,
    required this.nome,
    required this.email,
    required this.sexo,
    required this.nascimento,
  });

  factory AdmTech.fromJson(Map<String, dynamic> json) {
    return AdmTech(
      idTecnicoAdministrativo:
          json['idtecnicoadministrativo'] ?? json['idTecnicoAdministrativo'],
      nome: json['nome'],
      email: json['email'],
      sexo: json['sexo'] ?? '',
      nascimento: DateTime.parse(json['nascimento']),
    );
  }

  Map<String, dynamic> toJson() => {
        'idTecnicoAdministrativo': idTecnicoAdministrativo,
        'nome': nome,
        'email': email,
        'sexo': sexo,
        'nascimento': nascimento.toIso8601String(),
      };
}
