Definir Alfa vaOrig1;
Definir Alfa vaOrig2;
Definir Alfa vaOrig3;
Definir Alfa vaRev1;
Definir Alfa vaRev2;
Definir Alfa vaRev3;
Definir Alfa vaTemp;
Definir Alfa vaTam1;
Definir Alfa vaTam2;
Definir Alfa vaTam3;
Definir Alfa vaMsg;
Definir Numero vnTam1;
Definir Numero vnTam2;
Definir Numero vnTam3;
Definir Numero vnI;
Definir Numero vnUm;
vaOrig1 = "LSP";
vaOrig2 = "Senior";
vaOrig3 = "AB";
vaRev1 = "";
vaRev2 = "";
vaRev3 = "";
vnUm = 1;
TamanhoAlfa(vaOrig1, vnTam1);
TamanhoAlfa(vaOrig2, vnTam2);
TamanhoAlfa(vaOrig3, vnTam3);
Para (vnI = 1; vnI <= vnTam1; vnI++) {
  vaTemp = vaOrig1;
  CopiarAlfa(vaTemp, vnI, vnUm);
  vaRev1 = vaTemp + vaRev1;
}
Para (vnI = 1; vnI <= vnTam2; vnI++) {
  vaTemp = vaOrig2;
  CopiarAlfa(vaTemp, vnI, vnUm);
  vaRev2 = vaTemp + vaRev2;
}
Para (vnI = 1; vnI <= vnTam3; vnI++) {
  vaTemp = vaOrig3;
  CopiarAlfa(vaTemp, vnI, vnUm);
  vaRev3 = vaTemp + vaRev3;
}
IntParaAlfa(vnTam1, vaTam1);
IntParaAlfa(vnTam2, vaTam2);
IntParaAlfa(vnTam3, vaTam3);
vaMsg = "Caso 1: Original: LSP Tamanho: " + vaTam1 + " Invertida: " + vaRev1 + " Caso 2: Original: Senior Tamanho: " + vaTam2 + " Invertida: " + vaRev2 + " Caso 3: Original: AB Tamanho: " + vaTam3 + " Invertida: " + vaRev3;
Mensagem(Retorna, vaMsg);
