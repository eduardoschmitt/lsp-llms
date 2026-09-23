Definir Alfa vaPalavra;
Definir Numero vnTamanho;
Definir Numero vnI;
Definir Alfa vaChar;
Definir Alfa vaInvertida;
Definir Alfa vaTamStr1;
Definir Alfa vaTamStr2;
Definir Alfa vaTamStr3;
Definir Alfa vaInv1;
Definir Alfa vaInv2;
Definir Alfa vaInv3;
Definir Alfa vaMsg;

vaPalavra = "LSP";
TamanhoAlfa(vaPalavra, vnTamanho);
IntParaAlfa(vnTamanho, vaTamStr1);
vaInvertida = "";
Para (vnI = 1; vnI <= vnTamanho; vnI++) {
  vaChar = vaPalavra;
  CopiarAlfa(vaChar, vnI, 1);
  vaInvertida = vaChar + vaInvertida;
}
vaInv1 = vaInvertida;

vaPalavra = "Senior";
TamanhoAlfa(vaPalavra, vnTamanho);
IntParaAlfa(vnTamanho, vaTamStr2);
vaInvertida = "";
Para (vnI = 1; vnI <= vnTamanho; vnI++) {
  vaChar = vaPalavra;
  CopiarAlfa(vaChar, vnI, 1);
  vaInvertida = vaChar + vaInvertida;
}
vaInv2 = vaInvertida;

vaPalavra = "AB";
TamanhoAlfa(vaPalavra, vnTamanho);
IntParaAlfa(vnTamanho, vaTamStr3);
vaInvertida = "";
Para (vnI = 1; vnI <= vnTamanho; vnI++) {
  vaChar = vaPalavra;
  CopiarAlfa(vaChar, vnI, 1);
  vaInvertida = vaChar + vaInvertida;
}
vaInv3 = vaInvertida;

vaMsg = "Caso 1: Original: LSP Tamanho: " + vaTamStr1 + " Invertida: " + vaInv1 + " Caso 2: Original: Senior Tamanho: " + vaTamStr2 + " Invertida: " + vaInv2 + " Caso 3: Original: AB Tamanho: " + vaTamStr3 + " Invertida: " + vaInv3;
Mensagem(Retorna, vaMsg);
