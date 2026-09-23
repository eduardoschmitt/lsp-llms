Definir Numero vnG1N1;
Definir Numero vnG1N2;
Definir Numero vnG1N3;
Definir Numero vnG1N4;
Definir Numero vnG1N5;
Definir Numero vnG2N1;
Definir Numero vnG2N2;
Definir Numero vnG2N3;
Definir Numero vnG2N4;
Definir Numero vnG2N5;
Definir Numero vnG3N1;
Definir Numero vnG3N2;
Definir Numero vnG3N3;
Definir Numero vnG3N4;
Definir Numero vnG3N5;
Definir Numero vnSoma1;
Definir Numero vnSoma2;
Definir Numero vnSoma3;
Definir Numero vnMax1;
Definir Numero vnMax2;
Definir Numero vnMax3;
Definir Alfa vaSoma1;
Definir Alfa vaSoma2;
Definir Alfa vaSoma3;
Definir Alfa vaMax1;
Definir Alfa vaMax2;
Definir Alfa vaMax3;
Definir Alfa vaMsg;
vnG1N1 = 70;
vnG1N2 = 85;
vnG1N3 = 90;
vnG1N4 = 60;
vnG1N5 = 65;
vnG2N1 = 100;
vnG2N2 = 100;
vnG2N3 = 95;
vnG2N4 = 88;
vnG2N5 = 92;
vnG3N1 = 0;
vnG3N2 = 15;
vnG3N3 = 7;
vnG3N4 = 22;
vnG3N5 = 9;
vnSoma1 = vnG1N1 + vnG1N2;
vnSoma1 = vnSoma1 + vnG1N3;
vnSoma1 = vnSoma1 + vnG1N4;
vnSoma1 = vnSoma1 + vnG1N5;
vnSoma2 = vnG2N1 + vnG2N2;
vnSoma2 = vnSoma2 + vnG2N3;
vnSoma2 = vnSoma2 + vnG2N4;
vnSoma2 = vnSoma2 + vnG2N5;
vnSoma3 = vnG3N1 + vnG3N2;
vnSoma3 = vnSoma3 + vnG3N3;
vnSoma3 = vnSoma3 + vnG3N4;
vnSoma3 = vnSoma3 + vnG3N5;
vnMax1 = vnG1N1;
Se (vnG1N2 > vnMax1) {
  vnMax1 = vnG1N2;
}
Se (vnG1N3 > vnMax1) {
  vnMax1 = vnG1N3;
}
Se (vnG1N4 > vnMax1) {
  vnMax1 = vnG1N4;
}
Se (vnG1N5 > vnMax1) {
  vnMax1 = vnG1N5;
}
vnMax2 = vnG2N1;
Se (vnG2N2 > vnMax2) {
  vnMax2 = vnG2N2;
}
Se (vnG2N3 > vnMax2) {
  vnMax2 = vnG2N3;
}
Se (vnG2N4 > vnMax2) {
  vnMax2 = vnG2N4;
}
Se (vnG2N5 > vnMax2) {
  vnMax2 = vnG2N5;
}
vnMax3 = vnG3N1;
Se (vnG3N2 > vnMax3) {
  vnMax3 = vnG3N2;
}
Se (vnG3N3 > vnMax3) {
  vnMax3 = vnG3N3;
}
Se (vnG3N4 > vnMax3) {
  vnMax3 = vnG3N4;
}
Se (vnG3N5 > vnMax3) {
  vnMax3 = vnG3N5;
}
IntParaAlfa(vnSoma1, vaSoma1);
IntParaAlfa(vnMax1, vaMax1);
IntParaAlfa(vnSoma2, vaSoma2);
IntParaAlfa(vnMax2, vaMax2);
IntParaAlfa(vnSoma3, vaSoma3);
IntParaAlfa(vnMax3, vaMax3);
vaMsg = "Caso 1: Turma 1 - Soma: " + vaSoma1 + " Max: " + vaMax1 + " Caso 2: Turma 2 - Soma: " + vaSoma2 + " Max: " + vaMax2 + " Caso 3: Turma 3 - Soma: " + vaSoma3 + " Max: " + vaMax3;
Mensagem(Retorna, vaMsg);
