Definir Alfa vaHTTP;
Definir Alfa vaURL;
Definir Alfa vaResposta;
Definir Numero vnStatus;
Definir Alfa vaStatusStr;
Definir Alfa vaMensagem;
Definir Alfa vaURLResposta;

vaURL = "https://httpbin.org/get";

HttpObjeto(vaHTTP);
HttpSetaTimeout(vaHTTP, 30);
HttpGet(vaHTTP, vaURL, vaResposta);
HttpLeCodigoResposta(vaHTTP, vnStatus);

Se (vnStatus = 200) {
    ValorElementoJson(vaResposta, "", "url", vaURLResposta);
    vaMensagem = "HTTP OK: " + vaURLResposta;
    Mensagem(Retorna, vaMensagem);
} Senao {
    IntParaAlfa(vnStatus, vaStatusStr);
    vaMensagem = "HTTP ERRO Status: " + vaStatusStr;
    Mensagem(Retorna, vaMensagem);
}
