class Exercise {
  int idexercicio;
  String nome;
  String regiaoCorporea;
  String dica;
  String imagepath;
  double peso;
  double cargaMaxima;

  Exercise({
    this.idexercicio = -1,
    this.nome = '',
    this.regiaoCorporea = '',
    this.dica = '',
    this.imagepath = '',
    this.peso = 0.0,
    this.cargaMaxima = 0.0,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      idexercicio: json['idexercicio'],
      nome: json['nome_exercicio'],
      regiaoCorporea: json['regiao_corporea'],
      dica: json['dica'],
      imagepath: json['imagepath'] ?? '',
      peso: json['peso'] ?? 0.0,
      cargaMaxima: json['carga_maxima'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'idexercicio': idexercicio.toString(),
        'nome': nome,
        'regiao_corporea': regiaoCorporea,
        'dica': dica,
        'imagepath': imagepath,
        'peso': peso.toString(),
        'carga_maxima': cargaMaxima.toString(),
      };
}
