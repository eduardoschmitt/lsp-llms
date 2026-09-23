Definir Numero vnN;
Definir Numero vnContador;
Definir Numero vnSoma;
Definir Numero vnResto;
Definir Alfa vaSoma1;
Definir Alfa vaSoma2;
Definir Alfa vaSoma3;
Definir Alfa vaMsg;

vnN = 10;
vnSoma = 0;
Para (vnContador = 1; vnContador <= vnN; vnContador++) {
  RestoDivisao(vnContador, 2, vnResto);
  Se (vnResto = 0) {
    vnSoma = vnSoma + vnContador;
  }
}
IntParaAlfa(vnSoma, vaSoma1);

vnN = 100;
vnSoma = 0;
Para (vnContador = 1; vnContador <= vnN; vnContador++) {
  RestoDivisao(vnContador, 2, vnResto);
  Se (vnResto = 0) {
    vnSoma = vnSoma + vnContador;
  }
}
IntParaAlfa(vnSoma, vaSoma2);

vnN = 7;
vnSoma = 0;
Para (vnContador = 1; vnContador <= vnN; vnContador++) {
  RestoDivisao(vnContador, 2, vnResto);
  Se (vnResto = 0) {
    vnSoma = vnSoma + vnContador;
  }
}
IntParaAlfa(vnSoma, vaSoma3);

vaMsg = "Caso 1: Soma pares ate 10: " + vaSoma1 + " Caso 2: Soma pares ate 100: " + vaSoma2 + " Caso 3: Soma pares ate 7: " + vaSoma3;
Mensagem(Retorna, vaMsg);
