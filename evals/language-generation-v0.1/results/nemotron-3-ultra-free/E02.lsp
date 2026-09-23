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

vnNotas[0] = 70;
vnNotas[1] = 85;
vnNotas[2] = 90;
vnNotas[3] = 60;
vnNotas[4] = 65;

vnSoma1 = 0;
vnMax1 = vnNotas[0];
vnContador = 0;
Para (vnContador = 0; vnContador < 5; vnContador++) {
  vnSoma1 = vnSoma1 + vnNotas[vnContador];
  Se (vnNotas[vnContador] > vnMax1) {
    vnMax1 = vnNotas[vnContador];
  }
}

vnNotas[0] = 100;
vnNotas[1] = 100;
vnNotas[2] = 95;
vnNotas[3] = 88;
vnNotas[4] = 92;

vnSoma2 = 0;
vnMax2 = vnNotas[0];
vnContador = 0;
Para (vnContador = 0; vnContador < 5; vnContador++) {
  vnSoma2 = vnSoma2 + vnNotas[vnContador];
  Se (vnNotas[vnContador] > vnMax2) {
    vnMax2 = vnNotas[vnContador];
  }
}

vnNotas[0] = 0;
vnNotas[1] = 15;
vnNotas[2] = 7;
vnNotas[3] = 22;
vnNotas[4] = 9;

vnSoma3 = 0;
vnMax3 = vnNotas[0];
vnContador = 0;
Para (vnContador = 0; vnContador < 5; vnContador++) {
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
