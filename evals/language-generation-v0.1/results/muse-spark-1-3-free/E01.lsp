Definir Numero vnI;
Definir Numero vnN1;
Definir Numero vnN2;
Definir Numero vnN3;
Definir Numero vnSoma1;
Definir Numero vnSoma2;
Definir Numero vnSoma3;
Definir Numero vnResto;
Definir Numero vnDivisor;
Definir Alfa vaSoma1;
Definir Alfa vaSoma2;
Definir Alfa vaSoma3;
Definir Alfa vaMsg;
vnN1 = 10;
vnN2 = 100;
vnN3 = 7;
vnSoma1 = 0;
vnSoma2 = 0;
vnSoma3 = 0;
vnDivisor = 2;
Para (vnI = 1; vnI <= vnN1; vnI++) {
  RestoDivisao(vnI, vnDivisor, vnResto);
  Se (vnResto = 0) {
    vnSoma1 = vnSoma1 + vnI;
  }
}
Para (vnI = 1; vnI <= vnN2; vnI++) {
  RestoDivisao(vnI, vnDivisor, vnResto);
  Se (vnResto = 0) {
    vnSoma2 = vnSoma2 + vnI;
  }
}
Para (vnI = 1; vnI <= vnN3; vnI++) {
  RestoDivisao(vnI, vnDivisor, vnResto);
  Se (vnResto = 0) {
    vnSoma3 = vnSoma3 + vnI;
  }
}
IntParaAlfa(vnSoma1, vaSoma1);
IntParaAlfa(vnSoma2, vaSoma2);
IntParaAlfa(vnSoma3, vaSoma3);
vaMsg = "Caso 1: Soma pares ate 10: " + vaSoma1 + " Caso 2: Soma pares ate 100: " + vaSoma2 + " Caso 3: Soma pares ate 7: " + vaSoma3;
Mensagem(Retorna, vaMsg);
