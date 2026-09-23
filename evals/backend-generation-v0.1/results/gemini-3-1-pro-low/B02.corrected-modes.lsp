Definir Numero vnArquivo;
Definir Alfa vaCaminho;
Definir Numero vnLinhas;
Definir Numero vnExiste;
Definir Alfa vaTexto;
Definir Alfa vaLinhasStr;
Definir Alfa vaExisteStr;
Definir Alfa vaMensagem;

vaCaminho = "C:\\temp\\eval_b02.txt";

vnArquivo = Abrir(vaCaminho, Gravarnl);
Gravarnl(vnArquivo, "Alpha");
Gravarnl(vnArquivo, "Beta");
Gravarnl(vnArquivo, "Gama");
Fechar(vnArquivo);

LinhasArquivo(vaCaminho, vnLinhas);
Se (ArqExiste(vaCaminho) = 1) {
  vnExiste = 1;
} Senao {
  vnExiste = 0;
}

vnArquivo = Abrir(vaCaminho, Lernl);
Lernl(vnArquivo, vaTexto);
Fechar(vnArquivo);

IntParaAlfa(vnLinhas, vaLinhasStr);
IntParaAlfa(vnExiste, vaExisteStr);

vaMensagem = "B02 Linhas: " + vaLinhasStr + " Primeira: " + vaTexto + " Existe: " + vaExisteStr;
Mensagem(Retorna, vaMensagem);
