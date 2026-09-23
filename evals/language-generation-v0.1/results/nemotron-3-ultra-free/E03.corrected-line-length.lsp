Definir Alfa vaPalavra;
Definir Alfa vaTemp;
Definir Alfa vaChar;
Definir Alfa vaInvertida1;
Definir Alfa vaInvertida2;
Definir Alfa vaInvertida3;
Definir Numero vnTamanho1;
Definir Numero vnTamanho2;
Definir Numero vnTamanho3;
Definir Numero vnContador;
Definir Alfa vaTamanho1Str;
Definir Alfa vaTamanho2Str;
Definir Alfa vaTamanho3Str;
Definir Alfa vaMensagem;

vaPalavra = "LSP";
TamanhoAlfa(vaPalavra, vnTamanho1);
vaInvertida1 = "";
vnContador = vnTamanho1;
Para (vnContador = vnTamanho1; vnContador >= 1; vnContador--) {
  vaTemp = vaPalavra;
  CopiarAlfa(vaTemp, vnContador, 1);
  vaChar = vaTemp;
  vaInvertida1 = vaChar + vaInvertida1;
}

vaPalavra = "Senior";
TamanhoAlfa(vaPalavra, vnTamanho2);
vaInvertida2 = "";
vnContador = vnTamanho2;
Para (vnContador = vnTamanho2; vnContador >= 1; vnContador--) {
  vaTemp = vaPalavra;
  CopiarAlfa(vaTemp, vnContador, 1);
  vaChar = vaTemp;
  vaInvertida2 = vaChar + vaInvertida2;
}

vaPalavra = "AB";
TamanhoAlfa(vaPalavra, vnTamanho3);
vaInvertida3 = "";
vnContador = vnTamanho3;
Para (vnContador = vnTamanho3; vnContador >= 1; vnContador--) {
  vaTemp = vaPalavra;
  CopiarAlfa(vaTemp, vnContador, 1);
  vaChar = vaTemp;
  vaInvertida3 = vaChar + vaInvertida3;
}

IntParaAlfa(vnTamanho1, vaTamanho1Str);
IntParaAlfa(vnTamanho2, vaTamanho2Str);
IntParaAlfa(vnTamanho3, vaTamanho3Str);

vaMensagem = "Caso 1: Original: LSP Tamanho: " + vaTamanho1Str + " Invertida: " + vaInvertida1;
vaMensagem = vaMensagem + " Caso 2: Original: Senior Tamanho: " + vaTamanho2Str + " Invertida: " + vaInvertida2;
vaMensagem = vaMensagem + " Caso 3: Original: AB Tamanho: " + vaTamanho3Str + " Invertida: " + vaInvertida3;
Mensagem(Retorna, vaMensagem);
