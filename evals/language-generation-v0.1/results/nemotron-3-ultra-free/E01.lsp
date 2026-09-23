Definir Numero vnN1;
Definir Numero vnN2;
Definir Numero vnN3;
Definir Numero vnContador;
Definir Numero vnSoma1;
Definir Numero vnSoma2;
Definir Numero vnSoma3;
Definir Numero vnResto;
Definir Alfa vaSoma1Str;
Definir Alfa vaSoma2Str;
Definir Alfa vaSoma3Str;
Definir Alfa vaMensagem;

vnN1 = 10;
vnN2 = 100;
vnN3 = 7;

vnSoma1 = 0;
vnContador = 1;
Para (vnContador = 1; vnContador <= vnN1; vnContador++) {
  RestoDivisao(vnContador, 2, vnResto);
  Se (vnResto = 0) {
    vnSoma1 = vnSoma1 + vnContador;
  }
}

vnSoma2 = 0;
vnContador = 1;
Para (vnContador = 1; vnContador <= vnN2; vnContador++) {
  RestoDivisao(vnContador, 2, vnResto);
  Se (vnResto = 0) {
    vnSoma2 = vnSoma2 + vnContador;
  }
}

vnSoma3 = 0;
vnContador = 1;
Para (vnContador = 1; vnContador <= vnN3; vnContador++) {
  RestoDivisao(vnContador, 2, vnResto);
  Se (vnResto = 0) {
    vnSoma3 = vnSoma3 + vnContador;
  }
}

IntParaAlfa(vnSoma1, vaSoma1Str);
IntParaAlfa(vnSoma2, vaSoma2Str);
IntParaAlfa(vnSoma3, vaSoma3Str);

vaMensagem = "Caso 1: Soma pares ate 10: " + vaSoma1Str + " Caso 2: Soma pares ate 100: " + vaSoma2Str + " Caso 3: Soma pares ate 7: " + vaSoma3Str;
Mensagem(Retorna, vaMensagem);
