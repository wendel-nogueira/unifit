const exercisesList = [
  {"idexercicio": 1, "nome": "Supino Reto", "regiao_corporea": "Peito"},
  {
    "idexercicio": 2,
    "nome": "Flexão de Braço de Joelhos",
    "regiao_corporea": "Peito"
  },
  {"idexercicio": 3, "nome": "Flexão de Braço", "regiao_corporea": "Peito"},
  {"idexercicio": 4, "nome": "Crucifixo 45º", "regiao_corporea": "Peito"},
  {"idexercicio": 5, "nome": "Testa", "regiao_corporea": "Tríceps"},
  {"idexercicio": 6, "nome": "Corda", "regiao_corporea": "Tríceps"},
  {"idexercicio": 7, "nome": "Agachamento", "regiao_corporea": "Pernas"},
  {"idexercicio": 8, "nome": "Barra Fixa", "regiao_corporea": "Costas"},
  {"idexercicio": 9, "nome": "Leg Press", "regiao_corporea": "Pernas"},
  {"idexercicio": 10, "nome": "Extensora", "regiao_corporea": "Pernas"},
  {"idexercicio": 11, "nome": "Flexora", "regiao_corporea": "Pernas"},
  {"idexercicio": 12, "nome": "Stiff", "regiao_corporea": "Pernas"},
  {"idexercicio": 13, "nome": "Corda", "regiao_corporea": "Tríceps"},
  {
    "idexercicio": 14,
    "nome": "Desenvolvimento com Halter",
    "regiao_corporea": "Ombro"
  },
  {"idexercicio": 15, "nome": "Elavação Lateral", "regiao_corporea": "Ombro"},
  {"idexercicio": 16, "nome": "Remada Alta", "regiao_corporea": "Ombro"},
  {"idexercicio": 17, "nome": "Supino Reto", "regiao_corporea": "Peito"},
  {"idexercicio": 18, "nome": "Supino Inclinado", "regiao_corporea": "Peito"},
  {"idexercicio": 19, "nome": "Supino Declinado", "regiao_corporea": "Peito"},
  {"idexercicio": 20, "nome": "Crossover", "regiao_corporea": "Peito"},
  {"idexercicio": 21, "nome": "Peck Deck", "regiao_corporea": "Peito"},
  {"idexercicio": 22, "nome": "Flexão de Braço", "regiao_corporea": "Peito"},
  {"idexercicio": 23, "nome": "Supino Fechado", "regiao_corporea": "Peito"},
  {"idexercicio": 24, "nome": "Mergulho", "regiao_corporea": "Peito"},
  {
    "idexercicio": 25,
    "nome": "Pullover com Haltere",
    "regiao_corporea": "Peito"
  },
  {
    "idexercicio": 26,
    "nome": "Pullover com Barra, Deitado sobre o Banco",
    "regiao_corporea": "Peito"
  },
  {"idexercicio": 27, "nome": "Máquina de Peito", "regiao_corporea": "Peito"},
  {
    "idexercicio": 28,
    "nome": "Supino com Halteres",
    "regiao_corporea": "Peito"
  },
  {
    "idexercicio": 29,
    "nome": "Abdução-Adução, Deitado com Halteres",
    "regiao_corporea": "Peito"
  },
  {
    "idexercicio": 30,
    "nome": "Abdução-Adução com Aparelho",
    "regiao_corporea": "Peito"
  },
  {
    "idexercicio": 31,
    "nome": "Abdução-Adução em Pé",
    "regiao_corporea": "Peito"
  },
  {
    "idexercicio": 32,
    "nome": "Supino Inclinado com Halteres",
    "regiao_corporea": "Peito"
  },
  {
    "idexercicio": 33,
    "nome": "Dips ou Repulsão em Barras Paralelas",
    "regiao_corporea": "Peito"
  },
  {
    "idexercicio": 34,
    "nome": "Traçao na Barra Fixa",
    "regiao_corporea": "Costas"
  },
  {
    "idexercicio": 35,
    "nome": "Traçao na Barra Fixa, Mãos em Supinação",
    "regiao_corporea": "Costas"
  },
  {
    "idexercicio": 36,
    "nome": "Puxada Frontal com Polia Alta",
    "regiao_corporea": "Costas"
  },
  {
    "idexercicio": 37,
    "nome": "Puxada Atrás com Polia Alta",
    "regiao_corporea": "Costas"
  },
  {"idexercicio": 38, "nome": "Pull-Up", "regiao_corporea": "Costas"},
  {"idexercicio": 39, "nome": "Barra Fixa", "regiao_corporea": "Costas"},
  {"idexercicio": 40, "nome": "Puxada Frontal", "regiao_corporea": "Costas"},
  {"idexercicio": 41, "nome": "Puxada Alta", "regiao_corporea": "Costas"},
  {"idexercicio": 42, "nome": "Remada Curvada", "regiao_corporea": "Costas"},
  {"idexercicio": 43, "nome": "Pull-Down", "regiao_corporea": "Costas"},
  {"idexercicio": 44, "nome": "Hiperextensão", "regiao_corporea": "Costas"},
  {"idexercicio": 45, "nome": "T-Bar Row", "regiao_corporea": "Costas"},
  {"idexercicio": 46, "nome": "Máquina de Costas", "regiao_corporea": "Costas"},
  {"idexercicio": 47, "nome": "Deadlift", "regiao_corporea": "Costas"},
  {"idexercicio": 48, "nome": "Remada Unilateral", "regiao_corporea": "Costas"},
  {
    "idexercicio": 49,
    "nome": "Pull-Down com Corda",
    "regiao_corporea": "Costas"
  },
  {
    "idexercicio": 50,
    "nome": "Pull-Up com Pegada Neutra",
    "regiao_corporea": "Costas"
  },
  {
    "idexercicio": 51,
    "nome": "Puxada na Polia Baixa",
    "regiao_corporea": "Costas"
  },
  {"idexercicio": 52, "nome": "Bent-Over Row", "regiao_corporea": "Costas"},
  {
    "idexercicio": 53,
    "nome": "Remada com Barra T",
    "regiao_corporea": "Costas"
  },
  {
    "idexercicio": 54,
    "nome": "Pull-Down com Barra em V",
    "regiao_corporea": "Costas"
  },
  {
    "idexercicio": 55,
    "nome": "Máquina de Pull-Down",
    "regiao_corporea": "Costas"
  },
  {"idexercicio": 56, "nome": "Puxada Fechada", "regiao_corporea": "Costas"},
  {"idexercicio": 57, "nome": "Rosca Direta", "regiao_corporea": "Bíceps"},
  {"idexercicio": 58, "nome": "Rosca Scott", "regiao_corporea": "Bíceps"},
  {"idexercicio": 59, "nome": "Rosca 21", "regiao_corporea": "Bíceps"},
  {"idexercicio": 60, "nome": "Rosca Concentrada", "regiao_corporea": "Bíceps"},
  {"idexercicio": 61, "nome": "Rosca Martelo", "regiao_corporea": "Bíceps"},
  {"idexercicio": 62, "nome": "Rosca Inversa", "regiao_corporea": "Bíceps"},
  {
    "idexercicio": 63,
    "nome": "Martelada com Halteres",
    "regiao_corporea": "Bíceps"
  },
  {"idexercicio": 64, "nome": "Rosca Alternada", "regiao_corporea": "Bíceps"},
  {"idexercicio": 65, "nome": "Rosca 21", "regiao_corporea": "Bíceps"},
  {"idexercicio": 66, "nome": "Rosca com Corda", "regiao_corporea": "Bíceps"},
  {"idexercicio": 67, "nome": "Tríceps Pulldown", "regiao_corporea": "Tríceps"},
  {"idexercicio": 68, "nome": "Supino Fechado", "regiao_corporea": "Tríceps"},
  {"idexercicio": 69, "nome": "Paralelas", "regiao_corporea": "Tríceps"},
  {"idexercicio": 70, "nome": "Mergulho", "regiao_corporea": "Tríceps"},
  {
    "idexercicio": 71,
    "nome": "Extensão de Tríceps",
    "regiao_corporea": "Tríceps"
  },
  {"idexercicio": 72, "nome": "Tríceps Testa", "regiao_corporea": "Tríceps"},
  {"idexercicio": 73, "nome": "Tríceps Coice", "regiao_corporea": "Tríceps"},
  {"idexercicio": 74, "nome": "Tríceps Corda", "regiao_corporea": "Tríceps"},
  {"idexercicio": 75, "nome": "Tríceps Máquina", "regiao_corporea": "Tríceps"},
  {"idexercicio": 76, "nome": "Dips na Máquina", "regiao_corporea": "Tríceps"},
  {"idexercicio": 77, "nome": "Rosca de Punho", "regiao_corporea": "Antebraço"},
  {
    "idexercicio": 78,
    "nome": "Flexão de Punho",
    "regiao_corporea": "Antebraço"
  },
  {
    "idexercicio": 79,
    "nome": "Rolamento de Punho",
    "regiao_corporea": "Antebraço"
  },
  {
    "idexercicio": 80,
    "nome": "Rosca de Punho Inversa",
    "regiao_corporea": "Antebraço"
  },
  {
    "idexercicio": 81,
    "nome": "Martelada de Punho",
    "regiao_corporea": "Antebraço"
  },
  {
    "idexercicio": 82,
    "nome": "Máquina de Antebraço",
    "regiao_corporea": "Antebraço"
  },
  {
    "idexercicio": 83,
    "nome": "Puxador de Corda",
    "regiao_corporea": "Antebraço"
  },
  {
    "idexercicio": 84,
    "nome": "Extensor de Dedos",
    "regiao_corporea": "Antebraço"
  },
  {
    "idexercicio": 85,
    "nome": "Máquina de Antebraço",
    "regiao_corporea": "Antebraço"
  },
  {
    "idexercicio": 86,
    "nome": "Trabalho Manual",
    "regiao_corporea": "Antebraço"
  },
  {"idexercicio": 87, "nome": "Agachamento Livre", "regiao_corporea": "Pernas"},
  {"idexercicio": 88, "nome": "Leg Press", "regiao_corporea": "Pernas"},
  {"idexercicio": 89, "nome": "Cadeira Extensora", "regiao_corporea": "Pernas"},
  {"idexercicio": 90, "nome": "Cadeira Flexora", "regiao_corporea": "Pernas"},
  {"idexercicio": 91, "nome": "Agachamento Smith", "regiao_corporea": "Pernas"},
  {"idexercicio": 92, "nome": "Avanço", "regiao_corporea": "Pernas"},
  {"idexercicio": 93, "nome": "Cadeira Abdutora", "regiao_corporea": "Pernas"},
  {"idexercicio": 94, "nome": "Cadeira Adutora", "regiao_corporea": "Pernas"},
  {"idexercicio": 95, "nome": "Stiff", "regiao_corporea": "Pernas"},
  {
    "idexercicio": 96,
    "nome": "Máquina de Panturrilha",
    "regiao_corporea": "Pernas"
  },
  {
    "idexercicio": 97,
    "nome": "Desenvolvimento de Ombro",
    "regiao_corporea": "Ombros"
  },
  {"idexercicio": 98, "nome": "Elevação Frontal", "regiao_corporea": "Ombros"},
  {"idexercicio": 99, "nome": "Elevação Lateral", "regiao_corporea": "Ombros"},
  {
    "idexercicio": 100,
    "nome": "Desenvolvimento com Halteres",
    "regiao_corporea": "Ombros"
  },
  {"idexercicio": 101, "nome": "Máquina de Ombro", "regiao_corporea": "Ombros"},
  {
    "idexercicio": 102,
    "nome": "Encolhimento de Ombros",
    "regiao_corporea": "Ombros"
  },
  {
    "idexercicio": 103,
    "nome": "Elevação com Corda",
    "regiao_corporea": "Ombros"
  },
  {"idexercicio": 104, "nome": "Máquina de Ombro", "regiao_corporea": "Ombros"},
  {
    "idexercicio": 105,
    "nome": "Desenvolvimento com Barra",
    "regiao_corporea": "Ombros"
  },
  {
    "idexercicio": 106,
    "nome": "Elevação de Ombros na Smith",
    "regiao_corporea": "Ombros"
  },
  {"idexercicio": 107, "nome": "Prancha", "regiao_corporea": "Abdominais"},
  {"idexercicio": 108, "nome": "Crunch", "regiao_corporea": "Abdominais"},
  {
    "idexercicio": 109,
    "nome": "Elevação de Pernas",
    "regiao_corporea": "Abdominais"
  },
  {
    "idexercicio": 110,
    "nome": "Abdominal na Máquina",
    "regiao_corporea": "Abdominais"
  },
  {"idexercicio": 111, "nome": "Obliquo", "regiao_corporea": "Abdominais"},
  {
    "idexercicio": 112,
    "nome": "Prancha Lateral",
    "regiao_corporea": "Abdominais"
  },
  {
    "idexercicio": 113,
    "nome": "Prancha com Rotação",
    "regiao_corporea": "Abdominais"
  },
  {
    "idexercicio": 114,
    "nome": "Abdominal Inverso",
    "regiao_corporea": "Abdominais"
  },
  {
    "idexercicio": 115,
    "nome": "Máquina de Abdominais",
    "regiao_corporea": "Abdominais"
  },
  {
    "idexercicio": 115,
    "nome": "Abdominal Infra",
    "regiao_corporea": "Abdominais"
  },
];
