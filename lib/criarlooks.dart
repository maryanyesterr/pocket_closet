import 'package:flutter/material.dart';

// Widget Stateful porque gerencia campos de texto preenchíveis e estados de seleção
class CriarLook extends StatefulWidget {
  const CriarLook({super.key});

  @override
  State<CriarLook> createState() => _CriarLookState();
}

class _CriarLookState extends State<CriarLook> {
  // Controladores para capturar e automatizar os textos digitados nos formulários
  final TextEditingController _nomeController = TextEditingController(
    text: "Look casual",
  );
  final TextEditingController _ocasiaoController = TextEditingController(
    text: "Passeio / Dia a dia",
  );
  final TextEditingController _anotacoesController = TextEditingController(
    text: "Confortável e perfeito para dias frios",
  );

  // Lista que gera os botões redondos de categorias superiores automaticamente
  final List<Map<String, dynamic>> categoriasDeSelecao = [
    {'nome': 'Blusas', 'icone': Icons.checkroom_outlined},
    {'nome': 'Calças', 'icone': Icons.accessibility_new_outlined},
    {'nome': 'Calçados', 'icone': Icons.directions_walk_outlined},
    {'nome': 'Acessórios', 'icone': Icons.watch_outlined},
  ];

  // Map simulando as peças de roupa selecionadas atualmente para compor o look central
  final Map<String, String> lookSelecionado = {
    'blusa': 'assets/img/blusa_bege.png',
    'calca': 'assets/img/jeans_claro.png',
    'bolsa': 'assets/img/bolsa_marrom.png',
    'calcado': 'assets/img/tenis_branco.png',
  };

  @override
  void dispose() {
    // Descarta os controladores ao fechar a tela para evitar vazamento de memória (memory leak)
    _nomeController.dispose();
    _ocasiaoController.dispose();
    _anotacoesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white, // Define o fundo branco limpo conforme o protótipo
      body: SafeArea(
        // Impede que o conteúdo suma sob entalhes de tela (notch da câmera)
        child: SingleChildScrollView(
          // Permite rolar a tela se os campos ou o teclado ocuparem muito espaço
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TOPO: BOTÃO VOLTAR E TÍTULO PRINCIPAL
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.purple,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pop(
                          context,
                        ); // Comando para retornar à tela anterior
                      },
                    ),
                    const Text(
                      "Criar look",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 40), // Espaçador para manter o título centralizado por simetria
                  ],
                ),
                const SizedBox(height: 20),

                // ==================================================
                // BARRA HORIZONTAL DE SELEÇÃO DE CATEGORIAS
                // ==================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround, // Distribui igualmente os botões redondos
                  children: categoriasDeSelecao.map((cat) {
                    return Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ), // Contorno cinza suave
                          ),
                          child: Icon(
                            cat['icone'],
                            color: Colors.purple,
                            size: 24,
                          ), // Ícone representativo
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat['nome'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 25),

                // ==================================================
                // PAINEL CENTRAL DE VISUALIZAÇÃO DO LOOK (Quadrante 2x2)
                // ==================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFF7F4F0,
                    ), // Cor bege/cinza suave de fundo idêntica à imagem
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.count(
                    shrinkWrap: true, // Força o GridView a usar apenas o espaço necessário do conteúdo
                    physics: const NeverScrollableScrollPhysics(), // Desativa a rolagem interna do Grid
                    crossAxisCount: 2, // Define a divisão em 2 colunas
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      // Renderização automatizada de cada pedaço do look
                      _construirItemDoLook(lookSelecionado['blusa']!),
                      _construirItemDoLook(lookSelecionado['calca']!),
                      _construirItemDoLook(lookSelecionado['bolsa']!),
                      _construirItemDoLook(lookSelecionado['calcado']!),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // ==================================================
                // FORMULÁRIO: CAMPOS DE TEXTO AUTOMATIZADOS (TextFields)
                // ==================================================
                _construirCampoDeTexto("Nome do look", _nomeController),
                const SizedBox(height: 16),
                _construirCampoDeTexto("Ocasião", _ocasiaoController),
                const SizedBox(height: 16),
                _construirCampoDeTexto("Anotações", _anotacoesController),
                const SizedBox(height: 30),

                // ==================================================
                // BOTÃO INFERIOR ROXO: SALVAR LOOK
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(
                        81,
                        17,
                        147,
                        1,
                      ), // Roxo escuro do layout original
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          25,
                        ), // Bordas arredondadas e ovais
                      ),
                    ),
                    onPressed: () {
                      // Processamento Automatizado: Coleta os dados finais dos controladores
                      final String nomeLook = _nomeController.text;
                      final String ocasiaoLook = _ocasiaoController.text;
                      final String anotacoesLook = _anotacoesController.text;

                      // Aqui você pode enviar estas variáveis para salvar no banco de dados
                      debugPrint(
                        'Salvando Look: $nomeLook | $ocasiaoLook | $anotacoesLook',
                      );
                    },
                    child: const Text(
                      "Salvar look",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Função auxiliar para criar os blocos de imagem internos do painel central
  Widget _construirItemDoLook(String caminhoImagem) {
    return Center(
      child: Image.asset(
        caminhoImagem,
        fit: BoxFit.contain,
        // Fallback: se a imagem física não existir na pasta assets, coloca um cabide cinza para o app não quebrar
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.checkroom, size: 48, color: Colors.grey);
        },
      ),
    );
  }

  // Função auxiliar para construir e padronizar as caixas de digitação (formulários)
  Widget _construirCampoDeTexto(
    String label,
    TextEditingController controlador,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.amber.shade200,
              width: 1.5,
            ), // Borda fina amarela do design original
          ),
          child: TextField(
            controller: controlador, // Vincula o controlador dinâmico
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: const InputDecoration(
              border:
                  InputBorder.none, // Oculta a linha padrão inferior do Flutter
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ), // Alinhamento interno do texto
            ),
          ),
        ),
      ],
    );
  }
}
