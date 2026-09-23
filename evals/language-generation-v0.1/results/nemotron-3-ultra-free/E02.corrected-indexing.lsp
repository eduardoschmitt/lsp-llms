Definir Numero vnNotas[5];
Definir Numero vnSoma1;
Definir Numero vnSoma2;
Definir Numero vnSoma3;
Definir Numero vnMax1;
Definir Numero vnMax2;
Definir Numero vnMax3;
Definir Numero vnContador;
Definir Alfa vaSoma1Str;
Definir Alfa vaSoma2Str;
Definir Alfa vaSoma3Str;
Definir Alfa vaMax1Str;
Definir Alfa vaMax2Str;
Definir Alfa vaMax3Str;
Definir Alfa vaMensagem;

vnNotas[1] = 70;
vnNotas[2] = 85;
vnNotas[3] = 90;
vnNotas[4] = 60;
vnNotas[5] = 65;

vnSoma1 = 0;
vnMax1 = vnNotas[1];
vnContador = 1;
Para (vnContador = 1; vnContador <= 5; vnContador++) {
  vnSoma1 = vnSoma1 + vnNotas[vnContador];
  Se (vnNotas[vnContador] > vnMax1) {
    vnMax1 = vnNotas[vnContador];
  }
}

vnNotas[1] = 100;
vnNotas[2] = 100;
vnNotas[3] = 95;
vnNotas[4] = 88;
vnNotas[5] = 92;

vnSoma2 = 0;
vnMax2 = vnNotas[1];
vnContador = 1;
Para (vnContador = 1; vnContador <= 5; vnContador++) {
  vnSoma2 = vnSoma2 + vnNotas[vnContador];
  Se (vnNotas[vnContador] > vnMax2) {
    vnMax2 = vnNotas[vnContador];
  }
}

vnNotas[1] = 0;
vnNotas[2] = 15;
vnNotas[3] = 7;
vnNotas[4] = 22;
vnNotas[5] = 9;

vnSoma3 = 0;
vnMax3 = vnNotas[1];
vnContador = 1;
Para (vnContador = 1; vnContador <= 5; vnContador++) {
  vnSoma3 = vnSoma3 + vnNotas[vnContador];
  Se (vnNotas[vnContador] > vnMax3) {
    vnMax3 = vnNotas[vnContador];
  }
}

IntParaAlfa(vnSoma1, vaSoma1Str);
IntParaAlfa(vnMax1, vaMax1Str);
IntParaAlfa(vnSoma2, vaSoma2Str);
IntParaAlfa(vnMax2, vaMax2Str);
IntParaAlfa(vnSoma3, vaSoma3Str);
IntParaAlfa(vnMax3, vaMax3Str);

vaMensagem = "Caso 1: Turma 1 - Soma: " + vaSoma1Str + " Max: " + vaMax1Str + " Caso 2: Turma 2 - Soma: " + vaSoma2Str + " Max: " + vaMax2Str + " Caso 3: Turma 3 - Soma: " + vaSoma3Str + " Max: " + vaMax3Str;
Mensagem(Retorna, vaMensagem);
