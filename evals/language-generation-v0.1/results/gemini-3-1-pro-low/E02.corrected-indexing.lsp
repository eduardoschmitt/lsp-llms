Definir Numero vnNotas[5];
Definir Numero vnSoma;
Definir Numero vnMax;
Definir Numero vnI;
Definir Alfa vaSoma1;
Definir Alfa vaSoma2;
Definir Alfa vaSoma3;
Definir Alfa vaMax1;
Definir Alfa vaMax2;
Definir Alfa vaMax3;
Definir Alfa vaMsg;

vnNotas[1] = 70;
vnNotas[2] = 85;
vnNotas[3] = 90;
vnNotas[4] = 60;
vnNotas[5] = 65;

vnSoma = 0;
vnMax = vnNotas[1];
Para (vnI = 1; vnI <= 5; vnI++) {
  vnSoma = vnSoma + vnNotas[vnI];
  Se (vnNotas[vnI] > vnMax) {
    vnMax = vnNotas[vnI];
  }
}
IntParaAlfa(vnSoma, vaSoma1);
IntParaAlfa(vnMax, vaMax1);

vnNotas[1] = 100;
vnNotas[2] = 100;
vnNotas[3] = 95;
vnNotas[4] = 88;
vnNotas[5] = 92;

vnSoma = 0;
vnMax = vnNotas[1];
Para (vnI = 1; vnI <= 5; vnI++) {
  vnSoma = vnSoma + vnNotas[vnI];
  Se (vnNotas[vnI] > vnMax) {
    vnMax = vnNotas[vnI];
  }
}
IntParaAlfa(vnSoma, vaSoma2);
IntParaAlfa(vnMax, vaMax2);

vnNotas[1] = 0;
vnNotas[2] = 15;
vnNotas[3] = 7;
vnNotas[4] = 22;
vnNotas[5] = 9;

vnSoma = 0;
vnMax = vnNotas[1];
Para (vnI = 1; vnI <= 5; vnI++) {
  vnSoma = vnSoma + vnNotas[vnI];
  Se (vnNotas[vnI] > vnMax) {
    vnMax = vnNotas[vnI];
  }
}
IntParaAlfa(vnSoma, vaSoma3);
IntParaAlfa(vnMax, vaMax3);

vaMsg = "Caso 1: Turma 1 - Soma: " + vaSoma1 + " Max: " + vaMax1 + " Caso 2: Turma 2 - Soma: " + vaSoma2 + " Max: " + vaMax2 + " Caso 3: Turma 3 - Soma: " + vaSoma3 + " Max: " + vaMax3;
Mensagem(Retorna, vaMsg);
