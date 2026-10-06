import 'package:flutter/material.dart';

// Widget Stateful porque gerencia o clique nas abas de categorias e a ativação dos corações de favoritos.
class MeusLooks extends StatefulWidget {
  const MeusLooks({super.key});

  @override
  State<MeusLooks> createState() => _MeusLooksState();
}

class _MeusLooksState extends State<MeusLooks> {
  // Categoria selecionada que inicia ativa no aplicativo
  String categoriaSelecionada = 'Todos';

  // Lista dinâmica que gera o menu horizontal superior de filtros
  final List<String> categorias = [
    'Todos',
    'Favoritos',
    'Casual',
    'Trabalho',
    'Praia',
  ];

  // Banco de dados simulado e automatizado para gerenciar os looks cadastrados
  final List<Map<String, dynamic>> listaDeLooks = [
    {
      'titulo': 'Look casual',
      'data': '12/04/2026',
      'imagem': 'assets/img/look_casual.png', // Substitua pelos seus caminhos de assets reais
      'favorito': true, // Coração roxo preenchido
      'categoria': 'Casual',
    },
    {
      'titulo': 'Look trabalho',
      'data': '13/04/2026',
      'imagem': 'assets/img/look_trabalho.png',
      'favorito': false, // Coração amarelo/borda
      'categoria': 'Trabalho',
    },
    {
      'titulo': 'Look noite',
      'data': '15/04/2026',
      'imagem': 'assets/img/look_noite.png',
      'favorito': false,
      'categoria': 'Casual',
    },
    {
      'titulo': 'Look inverno',
      'data': '22/04/2026',
      'imagem': 'assets/img/look_inverno.png',
      'favorito': true,
      'categoria': 'Favoritos',
    },
    {
      'titulo': 'Look jeans',
      'data': '25/04/2026',
      'imagem': 'assets/img/look_jeans.png',
      'favorito': true,
      'categoria': 'Casual',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Regra automatizada de filtragem:
    // Se 'Todos' estiver selecionado, exibe tudo. Se for outra categoria, filtra correspondente.
    // Se a aba for 'Favoritos', ele traz apenas os itens onde 'favorito' é igual a true.
    final looksFiltrados = listaDeLooks.where((look) {
      if (categoriaSelecionada == 'Todos') return true;
      if (categoriaSelecionada == 'Favoritos') return look['favorito'] == true;
      return look['categoria'] == categoriaSelecionada;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco limpo igual à imagem
      body: SafeArea(
        // Protege o layout contra recortes de telas (entalhe/notch da câmera)
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TOPO: LOGO/VOLTAR, TÍTULO CENTRAL E BOTÃO MAIS (+)
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Distribui os elementos nas extremidades
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.purple,
                      size: 20,
                    ),
                    onPressed: () {
                      // Ação para navegar para a tela anterior
                    },
                  ),
                  const Text(
                    "Meus looks",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.purple,
                      size: 28,
                    ), // Botão de incluir novo look (+)
                    onPressed: () {
                      // Ação para criar/montar um novo look
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // ==================================================
              // ABAS FILTRADORAS HORIZONTAIS
              // ==================================================
              SizedBox(
                height: 35, // Altura reservada para os textos clicáveis
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Define a rolagem para os lados
                  itemCount: categorias.length,
                  itemBuilder: (context, index) {
                    final cat = categorias[index];
                    final bool isSelected = cat == categoriaSelecionada;

                    return GestureDetector(
                      onTap: () {
                        // Recarrega a interface aplicando o filtro da aba clicada
                        setState(() {
                          categoriaSelecionada = cat;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                        ), // Espaço de respiro entre as palavras
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat,
                              style: TextStyle(
                                color: isSelected ? Colors.purple : Colors.grey, // Roxo se ativo, cinza se inativo
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            // Pequena barra roxa indicadora abaixo da palavra selecionada
                            if (isSelected)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                height: 2,
                                width: 20,
                                color: Colors.purple,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),

              // ==================================================
              // GRID DE LOOKS (2 colunas automatizadas)
              // ==================================================
              Expanded(
                // O Expanded expande a grade para preencher todo o resto vertical da tela
                child: GridView.builder(
                  itemCount: looksFiltrados
                      .length, // Alimenta a grade baseado na filtragem atual
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Define exatamente duas colunas horizontais lado a lado
                    crossAxisSpacing:
                        16, // Espaçamento do vão do meio das colunas
                    mainAxisSpacing:
                        20, // Espaçamento entre as linhas verticais
                    childAspectRatio: 0.8, // Controla a proporção entre largura e altura dos blocos
                  ),
                  itemBuilder: (context, index) {
                    final look = looksFiltrados[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container do card visual do look (Fundo pastel/cinza claro)
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFF7F4F0,
                              ), // Cor bege/cinza bem suave de fundo do card
                              borderRadius: BorderRadius.circular(
                                15,
                              ), // Cantos arredondados
                            ),
                            child: Stack(
                              children: [
                                // Imagem centralizada do look completo
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      look['imagem'],
                                      fit: BoxFit.contain,
                                      // Impede a quebra visual se o arquivo físico não for encontrado
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.dry_cleaning,
                                              size: 50,
                                              color: Colors.grey,
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                // Botão de coração flutuante no canto superior direito do card
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Altera o estado interno de favorito deste item específico
                                      setState(() {
                                        look['favorito'] = !look['favorito'];
                                      });
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      size: 20,
                                      // Se for favorito, roxo. Caso contrário, cor amarela de borda
                                      color: look['favorito']
                                          ? Colors.purple
                                          : Colors.amber.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Título identificador do look (ex: Look casual)
                        Text(
                          look['titulo'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Data de registro ou último uso do visual
                        Text(
                          look['data'],
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
