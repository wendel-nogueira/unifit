class Assessment {
  int id;
  String peso;
  String altura;
  String torax;
  String cintura;
  String abdomen;
  String bracoEsquerdo;
  String bracoDireito;
  String antebracoEsquerdo;
  String antebracoDireito;
  String coxaDireito;
  String coxaEsquerdo;
  String pernaDireito;
  String pernaEsquerdo;
  String sunescapular;
  String toracica;
  String abdominal;
  String triceps;
  String axilar;
  String biceps;
  String supraIliaca;
  String panturrilha;
  String abdominalResistencia;

  Assessment({
    this.id = -1,
    this.peso = '',
    this.altura = '',
    this.torax = '',
    this.cintura = '',
    this.abdomen = '',
    this.bracoEsquerdo = '',
    this.bracoDireito = '',
    this.antebracoEsquerdo = '',
    this.antebracoDireito = '',
    this.coxaDireito = '',
    this.coxaEsquerdo = '',
    this.pernaDireito = '',
    this.pernaEsquerdo = '',
    this.sunescapular = '',
    this.toracica = '',
    this.abdominal = '',
    this.triceps = '',
    this.axilar = '',
    this.biceps = '',
    this.supraIliaca = '',
    this.panturrilha = '',
    this.abdominalResistencia = '',
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: int.parse(json['idavaliacao_fisica'].toString()),
      peso: json['peso'].toString(),
      altura: json['altura'].toString(),
      torax: json['torax'].toString(),
      cintura: json['cintura'].toString(),
      abdomen: json['abdomen'].toString(),
      bracoEsquerdo: json['braco_esquerdo'].toString(),
      bracoDireito: json['braco_direito'].toString(),
      antebracoEsquerdo: json['antebraco_esquerdo'].toString(),
      antebracoDireito: json['antebraco_direito'].toString(),
      coxaDireito: json['coxa_direito'].toString(),
      coxaEsquerdo: json['coxa_esquerdo'].toString(),
      pernaDireito: json['perna_direito'].toString(),
      pernaEsquerdo: json['perna_esquerdo'].toString(),
      sunescapular: json['sunescapular'].toString(),
      toracica: json['toracica'].toString(),
      abdominal: json['abdominal'].toString(),
      triceps: json['triceps'].toString(),
      axilar: json['axilar'].toString(),
      biceps: json['biceps'].toString(),
      supraIliaca: json['supra_iliaca'].toString(),
      panturrilha: json['panturrilha'].toString(),
      abdominalResistencia: json['abdominal_resistencia'],
    );
  }

  Map<String, dynamic> toJson(int studentId) => {
        'peso': peso,
        'altura': altura,
        'torax': torax,
        'cintura': cintura,
        'abdomen': abdomen,
        'braco_esquerdo': bracoEsquerdo,
        'braco_direito': bracoDireito,
        'antebraco_esquerdo': antebracoEsquerdo,
        'antebraco_direito': antebracoDireito,
        'coxa_direito': coxaDireito,
        'coxa_esquerdo': coxaEsquerdo,
        'perna_direito': pernaDireito,
        'perna_esquerdo': pernaEsquerdo,
        'sunescapular': sunescapular,
        'toracica': toracica,
        'abdominal': abdominal,
        'triceps': triceps,
        'axilar': axilar,
        'biceps': biceps,
        'supra_iliaca': supraIliaca,
        'panturrilha': panturrilha,
        'abdominal_resistencia': abdominalResistencia,
        'aluno_idaluno': studentId.toString(),
      };

  List<dynamic> getFormFields() {
    return [
      {
        'atribute': 'peso',
        'label': 'Peso (kg)',
        'value': peso,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'altura',
        'label': 'Altura (cm)',
        'value': altura,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'torax',
        'label': 'Tórax (cm)',
        'value': torax,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'cintura',
        'label': 'Cintura (cm)',
        'value': cintura,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'abdomen',
        'label': 'Abdômen (cm)',
        'value': abdomen,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'braco_esquerdo',
        'label': 'Braço Esquerdo (cm)',
        'value': bracoEsquerdo,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'braco_direito',
        'label': 'Braço Direito (cm)',
        'value': bracoDireito,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'antebraco_esquerdo',
        'label': 'Antebraço Esquerdo (cm)',
        'value': antebracoEsquerdo,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'antebraco_direito',
        'label': 'Antebraço Direito (cm)',
        'value': antebracoDireito,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'coxa_direito',
        'label': 'Coxa Direita (cm)',
        'value': coxaDireito,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'coxa_esquerdo',
        'label': 'Coxa Esquerda (cm)',
        'value': coxaEsquerdo,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'perna_direito',
        'label': 'Perna Direita (cm)',
        'value': pernaDireito,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'perna_esquerdo',
        'label': 'Perna Esquerda (cm)',
        'value': pernaEsquerdo,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'sunescapular',
        'label': 'Sunescaular (cm)',
        'value': sunescapular,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'toracica',
        'label': 'Torácica (cm)',
        'value': toracica,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'abdominal',
        'label': 'Abdominal (cm)',
        'value': abdominal,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'triceps',
        'label': 'Tríceps (cm)',
        'value': triceps,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'axilar',
        'label': 'Axilar (cm)',
        'value': axilar,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'biceps',
        'label': 'Bíceps (cm)',
        'value': biceps,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'supra_iliaca',
        'label': 'Supra Ilíaca (cm)',
        'value': supraIliaca,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'panturrilha',
        'label': 'Panturrilha (cm)',
        'value': panturrilha,
        'type': 'number',
        'required': true,
      },
      {
        'atribute': 'abdominal_resistencia',
        'label': 'Abdominal Resistência',
        'value': abdominalResistencia,
        'type': 'select',
        'options': ['fraca', 'leve', 'média', 'alta', 'muito alta'],
        'required': true,
      },
    ];
  }

  void updateValue(String atribute, dynamic value) {
    switch (atribute) {
      case 'peso':
        peso = value;
        break;
      case 'altura':
        altura = value;
        break;
      case 'torax':
        torax = value;
        break;
      case 'cintura':
        cintura = value;
        break;
      case 'abdomen':
        abdomen = value;
        break;
      case 'braco_esquerdo':
        bracoEsquerdo = value;
        break;
      case 'braco_direito':
        bracoDireito = value;
        break;
      case 'antebraco_esquerdo':
        antebracoEsquerdo = value;
        break;
      case 'antebraco_direito':
        antebracoDireito = value;
        break;
      case 'coxa_direito':
        coxaDireito = value;
        break;
      case 'coxa_esquerdo':
        coxaEsquerdo = value;
        break;
      case 'perna_direito':
        pernaDireito = value;
        break;
      case 'perna_esquerdo':
        pernaEsquerdo = value;
        break;
      case 'sunescapular':
        sunescapular = value;
        break;
      case 'toracica':
        toracica = value;
        break;
      case 'abdominal':
        abdominal = value;
        break;
      case 'triceps':
        triceps = value;
        break;
      case 'axilar':
        axilar = value;
        break;
      case 'biceps':
        biceps = value;
        break;
      case 'supra_iliaca':
        supraIliaca = value;
        break;
      case 'panturrilha':
        panturrilha = value;
        break;
      case 'abdominal_resistencia':
        abdominalResistencia = value;
        break;
      default:
        break;
    }
  }
}
