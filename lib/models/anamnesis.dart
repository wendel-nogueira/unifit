class Anamnesis {
  String patologia;
  String medicamentos;
  String alergia;
  String dieta;
  String lesoes;
  String cirurgias;
  String tabagismo;
  String alcoolismo;
  String hereditariedade;
  String esporte;
  String stress;
  String ansiedade;
  String depressao;
  String acompanhamentoMedico;
  String tratamento;
  String sintomas;
  String situacaoAtual;
  String gatilhos;

  Anamnesis({
    this.patologia = '',
    this.medicamentos = '',
    this.alergia = '',
    this.dieta = '',
    this.lesoes = '',
    this.cirurgias = '',
    this.tabagismo = '',
    this.alcoolismo = '',
    this.hereditariedade = '',
    this.esporte = '',
    this.stress = '',
    this.ansiedade = '',
    this.depressao = '',
    this.acompanhamentoMedico = '',
    this.tratamento = '',
    this.sintomas = '',
    this.situacaoAtual = '',
    this.gatilhos = '',
  });

  factory Anamnesis.fromJson(Map<String, dynamic> json) {
    return Anamnesis(
      patologia: json['patologia'],
      medicamentos: json['medicamentos'],
      alergia: json['alergia'],
      dieta: json['dieta'],
      lesoes: json['lesoes'],
      cirurgias: json['cirurgias'],
      tabagismo: json['tabagismo'],
      alcoolismo: json['alcoolismo'],
      hereditariedade: json['hereditariedade'],
      esporte: json['esporte'],
      stress: json['stress'],
      ansiedade: json['ansiedade'],
      depressao: json['depressao'],
      acompanhamentoMedico:
          json['acompanhamento_medico'] ?? json['acompanhamentoMedico'],
      tratamento: json['tratamento'],
      sintomas: json['sintomas'],
      situacaoAtual: json['situacao_atual'] ?? json['situacaoAtual'],
      gatilhos: json['gatilhos'],
    );
  }

  Map<String, dynamic> toJson(int studentId) => {
        'patologia': patologia,
        'medicamentos': medicamentos,
        'alergia': alergia,
        'dieta': dieta,
        'lesoes': lesoes,
        'cirurgias': cirurgias,
        'tabagismo': tabagismo,
        'alcoolismo': alcoolismo,
        'hereditariedade': hereditariedade,
        'esporte': esporte,
        'stress': stress,
        'ansiedade': ansiedade,
        'depressao': depressao,
        'acompanhamento_medico': acompanhamentoMedico,
        'tratamento': tratamento,
        'sintomas': sintomas,
        'situacao_atual': situacaoAtual,
        'gatilhos': gatilhos,
        'aluno_idaluno': studentId.toString(),
      };

  List<dynamic> getFormFields() {
    List<dynamic> fields = [
      {
        'atribute': 'patologia',
        'label': 'Patologia',
        'value': patologia,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'medicamentos',
        'label': 'Medicamentos',
        'value': medicamentos,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'alergia',
        'label': 'Alergia',
        'value': alergia,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'dieta',
        'label': 'Dieta',
        'value': dieta,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'lesoes',
        'label': 'Lesões',
        'value': lesoes,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'cirurgias',
        'label': 'Cirurgias',
        'value': cirurgias,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'tabagismo',
        'label': 'Tabagismo',
        'value': tabagismo,
        'type': 'select',
        'options': ['Não', 'Diário', 'Semanal', 'Ocasional', 'Ocasional Raro'],
        'required': true,
      },
      {
        'atribute': 'alcoolismo',
        'label': 'Alcoolismo',
        'value': alcoolismo,
        'type': 'select',
        'options': ['Não', 'Diário', 'Semanal', 'Ocasional', 'Ocasional Raro'],
        'required': true,
      },
      {
        'atribute': 'hereditariedade',
        'label': 'Hereditariedade',
        'value': hereditariedade,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'esporte',
        'label': 'Esporte',
        'value': esporte,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'stress',
        'label': 'Stress',
        'value': stress,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'ansiedade',
        'label': 'Ansiedade',
        'value': ansiedade,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'depressao',
        'label': 'Depressão',
        'value': depressao,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'acompanhamentoMedico',
        'label': 'Acompanhamento Médico',
        'value': acompanhamentoMedico,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'tratamento',
        'label': 'Tratamento',
        'value': tratamento,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'sintomas',
        'label': 'Sintomas',
        'value': sintomas,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'situacaoAtual',
        'label': 'Situação Atual',
        'value': situacaoAtual,
        'type': 'text',
        'length': 45,
        'required': true,
      },
      {
        'atribute': 'gatilhos',
        'label': 'Gatilhos',
        'value': gatilhos,
        'type': 'text',
        'length': 45,
        'required': true,
      }
    ];

    return fields;
  }

  void updateValue(String atribute, dynamic value) {
    switch (atribute) {
      case 'patologia':
        patologia = value;
        break;
      case 'medicamentos':
        medicamentos = value;
        break;
      case 'alergia':
        alergia = value;
        break;
      case 'dieta':
        dieta = value;
        break;
      case 'lesoes':
        lesoes = value;
        break;
      case 'cirurgias':
        cirurgias = value;
        break;
      case 'tabagismo':
        tabagismo = value;
        break;
      case 'alcoolismo':
        alcoolismo = value;
        break;
      case 'hereditariedade':
        hereditariedade = value;
        break;
      case 'esporte':
        esporte = value;
        break;
      case 'stress':
        stress = value;
        break;
      case 'ansiedade':
        ansiedade = value;
        break;
      case 'depressao':
        depressao = value;
        break;
      case 'acompanhamentoMedico':
        acompanhamentoMedico = value;
        break;
      case 'tratamento':
        tratamento = value;
        break;
      case 'sintomas':
        sintomas = value;
        break;
      case 'situacaoAtual':
        situacaoAtual = value;
        break;
      case 'gatilhos':
        gatilhos = value;
        break;
      default:
        break;
    }
  }
}
