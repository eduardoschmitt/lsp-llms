Definir Alfa vaJSON;
Definir Alfa vaNome;
Definir Alfa vaCidade;
Definir Numero vnListaItens;
Definir Alfa vaAchou;
Definir Alfa vaObteve;
Definir Alfa vaCod1;
Definir Alfa vaQtd1;
Definir Alfa vaCod2;
Definir Alfa vaQtd2;
Definir Alfa vaMensagem;

vaJSON = "{\"empresa\": {\"nome\": \"Tech\", \"cidade\": \"SP\"}, \"itens\": [{\"cod\": \"A1\", \"qtd\": 2}, {\"cod\": \"B2\", \"qtd\": 5}]}";

ValorElementoJson(vaJSON, "empresa", "nome", vaNome);
ValorElementoJson(vaJSON, "empresa", "cidade", vaCidade);

ListaRegraCriarLista(vnListaItens);
ListaRegraCarregarJson(vnListaItens, vaJSON, "itens", "cod;qtd");

ListaRegraPrimeiro(vnListaItens, vaAchou);
ListaRegraObterValorAlfa(vnListaItens, "cod", vaCod1, vaObteve);
ListaRegraObterValorAlfa(vnListaItens, "qtd", vaQtd1, vaObteve);

ListaRegraProximo(vnListaItens, vaAchou);
ListaRegraObterValorAlfa(vnListaItens, "cod", vaCod2, vaObteve);
ListaRegraObterValorAlfa(vnListaItens, "qtd", vaQtd2, vaObteve);

vaMensagem = "JSON Empresa: " + vaNome + " (" + vaCidade + ") Item1: " + vaCod1 + " x" + vaQtd1 + " Item2: " + vaCod2 + " x" + vaQtd2;
Mensagem(Retorna, vaMensagem);
