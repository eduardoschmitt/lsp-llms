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

vnNotas[0] = 70;
vnNotas[1] = 85;
vnNotas[2] = 90;
vnNotas[3] = 60;
vnNotas[4] = 65;

vnSoma = 0;
vnMax = vnNotas[0];
Para (vnI = 0; vnI < 5; vnI++) {
  vnSoma = vnSoma + vnNotas[vnI];
  Se (vnNotas[vnI] > vnMax) {
    vnMax = vnNotas[vnI];
  }
}
IntParaAlfa(vnSoma, vaSoma1);
IntParaAlfa(vnMax, vaMax1);

vnNotas[0] = 100;
vnNotas[1] = 100;
vnNotas[2] = 95;
vnNotas[3] = 88;
vnNotas[4] = 92;

vnSoma = 0;
vnMax = vnNotas[0];
Para (vnI = 0; vnI < 5; vnI++) {
  vnSoma = vnSoma + vnNotas[vnI];
  Se (vnNotas[vnI] > vnMax) {
    vnMax = vnNotas[vnI];
  }
}
IntParaAlfa(vnSoma, vaSoma2);
IntParaAlfa(vnMax, vaMax2);

vnNotas[0] = 0;
vnNotas[1] = 15;
vnNotas[2] = 7;
vnNotas[3] = 22;
vnNotas[4] = 9;

vnSoma = 0;
vnMax = vnNotas[0];
Para (vnI = 0; vnI < 5; vnI++) {
  vnSoma = vnSoma + vnNotas[vnI];
  Se (vnNotas[vnI] > vnMax) {
    vnMax = vnNotas[vnI];
  }
}
IntParaAlfa(vnSoma, vaSoma3);
IntParaAlfa(vnMax, vaMax3);

vaMsg = "Caso 1: Turma 1 - Soma: " + vaSoma1 + " Max: " + vaMax1 + " Caso 2: Turma 2 - Soma: " + vaSoma2 + " Max: " + vaMax2 + " Caso 3: Turma 3 - Soma: " + vaSoma3 + " Max: " + vaMax3;
Mensagem(Retorna, vaMsg);
