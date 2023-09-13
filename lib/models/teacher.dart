// idprofessor integer NOT NULL DEFAULT nextval('unifit.professor_idprofessor_seq'::regclass),
// nome character varying(45) COLLATE pg_catalog."default" NOT NULL,
// email character varying(45) COLLATE pg_catalog."default" NOT NULL,
// nascimento date,
// sexo character varying(10) COLLATE pg_catalog."default",
// senha character varying(100) COLLATE pg_catalog."default" NOT NULL,
// isestagiario boolean NOT NULL,

class Teacher {
  int idProfessor;
  String nome;
  String email;
  DateTime nascimento;
  String sexo;
  bool isEstagiario;

  Teacher({
    required this.idProfessor,
    required this.nome,
    required this.email,
    required this.nascimento,
    required this.sexo,
    required this.isEstagiario,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      idProfessor: json['idprofessor'] ?? json['idProfessor'],
      nome: json['nome'],
      email: json['email'],
      nascimento: DateTime.parse(json['nascimento']),
      sexo: json['sexo'] ?? '',
      isEstagiario: json['isestagiario'] ?? json['isEstagiario'],
    );
  }

  Map<String, dynamic> toJson() => {
        'idProfessor': idProfessor,
        'nome': nome,
        'email': email,
        'nascimento': nascimento.toIso8601String(),
        'sexo': sexo,
        'isEstagiario': isEstagiario,
      };
}
