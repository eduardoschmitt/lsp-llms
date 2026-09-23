Definir Alfa vaHTTP;
Definir Alfa vaURL;
Definir Alfa vaResposta;
Definir Numero vnStatus;
Definir Alfa vaStatusStr;
Definir Alfa vaMensagem;

vaURL = "https://www.senior.com.br/index.htm";

HttpObjeto(vaHTTP);
HttpSetaTimeout(vaHTTP, 30);
HttpGet(vaHTTP, vaURL, vaResposta);
HttpLeCodigoResposta(vaHTTP, vnStatus);

Se (vnStatus = 200) {
    vaMensagem = "HTTP OK Corpo: OK";
    Mensagem(Retorna, vaMensagem);
} Senao {
    IntParaAlfa(vnStatus, vaStatusStr);
    vaMensagem = "HTTP ERRO Status: " + vaStatusStr;
    Mensagem(Retorna, vaMensagem);
}
