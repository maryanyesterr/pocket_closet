import 'package:flutter/material.dart';

// Widget com estado (Stateful) porque o usuário vai interagir com a tela (filtrar categorias, favoritar roupas).
class GuardaRoupa extends StatefulWidget {
  const GuardaRoupa({super.key});

  @override
  State<GuardaRoupa> createState() => _GuardaRoupaState();
}

class _GuardaRoupaState extends State<GuardaRoupa> {
  // Guarda qual categoria está ativa no momento. Começa mostrando 'Todos'.
  String categoriaSelecionada = 'Todos';

  // Lista de textos que cria o menu de abas horizontal superior.
  final List<String> categorias = [
    'Todos',
    'Blusas',
    'Calças',
    'Vestidos',
    'Casacos',
  ];

  // Base de dados local (simulada) em formato de Lista de Mapas.
  // Centraliza as informações para que novos itens apareçam na tela sozinhos.
  final List<Map<String, dynamic>> minhasPecas = [
    {
      'nome': 'Blusa bege',
      'imagem': 'assets/img/blusa_bege.png', // Caminho interno da imagem no seu projeto
      'favorito': true, // Define se o ícone de coração começa preenchido
      'categoria': 'Blusas', // Categoria usada no filtro automático
    },
    {
      'nome': 'Jaqueta azul',
      'imagem': 'assets/img/jaqueta_azul.png',
      'favorito': false,
      'categoria': 'Casacos',
    },
    {
      'nome': 'Casaco bege',
      'imagem': 'assets/img/casaco_bege.png',
      'favorito': false,
      'categoria': 'Casacos',
    },
    {
      'nome': 'Vestido preto',
      'imagem': 'assets/img/vestido_preto.png',
      'favorito': false,
      'categoria': 'Vestidos',
    },
    {
      'nome': 'Jeans azul claro',
      'imagem': 'assets/img/jeans_claro.png',
      'favorito': true,
      'categoria': 'Calças',
    },
    {
      'nome': 'Tênis branco',
      'imagem': 'assets/img/tenis_branco.png',
      'favorito': true,
      'categoria': 'Todos',
    },
    {
      'nome': 'Bolsa marrom',
      'imagem': 'assets/img/bolsa_marrom.png',
      'favorito': false,
      'categoria': 'Todos',
    },
    {
      'nome': 'Óculos escuros',
      'imagem': 'assets/img/oculos_escuros.png',
      'favorito': false,
      'categoria': 'Todos',
    },
    {
      'nome': 'Chapéu bege',
      'imagem': 'assets/img/chapeu_bege.png',
      'favorito': false,
      'categoria': 'Todos',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Linha automatizada: se a categoria for 'Todos', pega a lista inteira.
    // Se for outra, filtra apenas os itens que pertencem à categoria clicada.
    final pecasFiltradas = categoriaSelecionada == 'Todos'
        ? minhasPecas
        : minhasPecas
              .where((peca) => peca['categoria'] == categoriaSelecionada)
              .toList();

    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco igual ao protótipo
      body: SafeArea(
        // SafeArea impede que o conteúdo fique escondido sob a câmera (notch) ou barras do sistema
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ), // Margens laterais e verticais
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TOPO: BOTÃO DE VOLTAR, TÍTULO E FILTRO
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaça os elementos (esquerda, centro e direita)
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.purple,
                      size: 20,
                    ),
                    onPressed: () {
                      // Ação para voltar de tela
                    },
                  ),
                  const Text(
                    "Guarda-roupa",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.tune,
                      color: Colors.purple,
                    ), // Ícone de configurações/filtros do lado direito
                    onPressed: () {
                      // Ação para abrir filtros avançados
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15), // Espaçador vertical
              // ==================================================
              // BARRA DE PESQUISA
              // ==================================================
              Container(
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF5F5F5,
                  ), // Cinza bem claro para o fundo da barra
                  borderRadius: BorderRadius.circular(
                    30,
                  ), // Bordas arredondadas ovais
                  border: Border.all(
                    color: Colors.amber.shade400,
                    width: 1.5,
                  ), // Borda amarela do layout
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar peças",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.purple,
                    ), // Lupa roxa à esquerda
                    border: InputBorder
                        .none, // Remove a linha padrão do TextField do Flutter
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 14,
                    ), // Alinha o texto internamente
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ==================================================
              // MENU HORIZONTAL DE CATEGORIAS (Filtro Dinâmico)
              // ==================================================
              SizedBox(
                height: 35, // Define a altura limite para a barra horizontal de botões
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Faz a lista rolar para os lados
                  itemCount: categorias
                      .length, // Quantidade de botões gerados automaticamente
                  itemBuilder: (context, index) {
                    final cat = categorias[index];
                    // Verifica se esta aba específica é a selecionada pelo usuário
                    final bool isSelected = cat == categoriaSelecionada;

                    return GestureDetector(
                      onTap: () {
                        // O setState avisa o Flutter para atualizar e redesenhar a tela com o novo filtro
                        setState(() {
                          categoriaSelecionada = cat;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 15,
                        ), // Espaço entre um botão e outro
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          // Se estiver selecionado, fica roxo. Se não, fica um roxo quase invisível de fundo.
                          color: isSelected
                              ? Colors.purple
                              : Colors.purple.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            // Troca a cor do texto dependendo se o botão está ativo ou inativo
                            color: isSelected ? Colors.white : Colors.purple,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // ==================================================
              // GRID DE ROUPAS (Grelha de 3 colunas automatizada)
              // ==================================================
              Expanded(
                // O Expanded faz a tabela ocupar todo o resto do espaço disponível na tela
                child: GridView.builder(
                  itemCount: pecasFiltradas.length, // Renderiza apenas a quantidade de itens do filtro ativo
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        3, // Força a exibição de exatamente 3 itens por linha
                    crossAxisSpacing:
                        12, // Espaçamento horizontal entre os cards
                    mainAxisSpacing:
                        12, // Espaçamento vertical entre as linhas de cards
                    childAspectRatio: 0.75, // Ajusta o esticamento vertical (largura dividida pela altura)
                  ),
                  itemBuilder: (context, index) {
                    final item = pecasFiltradas[index];

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.amber.shade200,
                          width: 1,
                        ), // Borda fina amarelada externa
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(
                              0.1,
                            ), // Sombra suave abaixo do card
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        // O Stack permite colocar o botão do coração por cima da imagem da roupa
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      item['imagem'],
                                      fit: BoxFit.contain, // Mantém a proporção da imagem sem distorcer
                                      // Evita que o app quebre se o arquivo físico da imagem não existir ainda:
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.checkroom,
                                              size: 40,
                                              color: Colors.grey,
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item['nome'], // Nome dinâmico obtido da lista
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1, // Não deixa o texto quebrar duas linhas
                                  overflow: TextOverflow.ellipsis, // Corta com "..." se o nome for grande demais
                                ),
                              ],
                            ),
                          ),
                          // Posiciona o botão do coração exatamente no canto inferior direito de cada card
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                // Inverte o estado de favorito do item ao clicar
                                setState(() {
                                  item['favorito'] = !item['favorito'];
                                });
                              },
                              child: Icon(
                                // Se for favorito exibe o coração cheio, caso contrário exibe apenas o contorno
                                item['favorito']
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18,
                                color: item['favorito']
                                    ? Colors.purple
                                    : Colors.amber,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // ==================================================
              // BOTÃO INFERIOR ROXO: ADICIONAR PEÇA
              // ==================================================
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SizedBox(
                  width: double.infinity, // Ocupa a largura total da tela
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.purple, // Cor roxa principal do botão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          25,
                        ), // Bordas arredondadas do botão
                      ),
                    ),
                    onPressed: () {
                      // Código para disparar a abertura da câmera ou galeria futuramente
                    },
                    child: const Text(
                      "Adicionar peça",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),      
    );
  }
}
