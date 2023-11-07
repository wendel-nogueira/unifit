class Frequency {
  int idfrequencia;
  DateTime dataHora;
  int alunoParticipaProjetoIdservico;
  int alunoParticipaAlunoIdaluno;
  int tecnicoAdministrativoIdtecnicoAdministrativo;

  Frequency({
    required this.idfrequencia,
    required this.dataHora,
    required this.alunoParticipaProjetoIdservico,
    required this.alunoParticipaAlunoIdaluno,
    required this.tecnicoAdministrativoIdtecnicoAdministrativo,
  });

  factory Frequency.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['data_hora']);

    date = date.subtract(const Duration(hours: 3));

    return Frequency(
      idfrequencia: json['idfrequencia'],
      dataHora: date,
      alunoParticipaProjetoIdservico:
          json['aluno_participa_projeto_idservico'] ?? 0,
      alunoParticipaAlunoIdaluno: json['aluno_participa_aluno_idaluno'] ?? 0,
      tecnicoAdministrativoIdtecnicoAdministrativo:
          json['tecnico_administrativo_idtecnico_administrativo'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'idfrequencia': idfrequencia,
        'data_hora': dataHora.toIso8601String(),
        'aluno_participa_projeto_idservico': alunoParticipaProjetoIdservico,
        'aluno_participa_aluno_idaluno': alunoParticipaAlunoIdaluno,
        'tecnico_administrativo_idtecnico_administrativo':
            tecnicoAdministrativoIdtecnicoAdministrativo,
      };
}
