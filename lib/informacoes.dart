import 'package:flutter/material.dart';
import 'package:pocket_closet/dashboard.dart';

class Informacoes extends StatefulWidget {
  const Informacoes({super.key});

  @override
  State<Informacoes> createState() => _InformacoesState();
}

class _InformacoesState extends State<Informacoes> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Dados Etapa 1: Estilo e Objetivos
  final Set<String> _selectedStyles = {'Casual', 'Minimalista'};
  final Set<String> _selectedObjectives = {'👗 Montar looks'};

  final List<String> _styles = [
    'Casual',
    'Elegante',
    'Streetwear',
    'Minimalista',
    'Colorido',
    'Romântico',
    'Esportivo',
    'Boho',
    'Gótico',
    'Grunge',
  ];

  final List<String> _objectives = [
    '💸 Economizar',
    '🎀 Organizar',
    '👗 Montar looks',
    '♻️ Sustentabilidade',
    '✈️ Viagens',
    '💼 Trabalho/Faculdade',
  ];

  // Dados Etapa 2: Medidas e Tamanhos
  String _selectedSize = 'M';
  final List<String> _sizes = ['PP', 'P', 'M', 'G', 'GG', 'XGG'];

  final TextEditingController _bustoCtrl = TextEditingController(text: '90');
  final TextEditingController _cinturaCtrl = TextEditingController(text: '80');
  final TextEditingController _quadrilCtrl = TextEditingController(text: '98');
  final TextEditingController _alturaCtrl = TextEditingController(text: '1,68');

  @override
  void dispose() {
    _pageController.dispose();
    _bustoCtrl.dispose();
    _cinturaCtrl.dispose();
    _quadrilCtrl.dispose();
    _alturaCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      // Aqui você pode salvar _selectedStyles, _selectedObjectives, medidas e _selectedSize
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Dashboard()),
        (route) => false,
      );
    }
  }

  void _previousStep() {
    if (_currentStep == 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO FIXO E BARRA DE PROGRESSO DINÂMICA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (_currentStep == 1)
                           
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              onPressed: _previousStep,
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 20,
                                color: Color(0xFF6A1B9A),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Passo ${_currentStep + 1} de 2',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      tween: Tween<double>(
                        begin: 0.5,
                        end: _currentStep == 0 ? 0.5 : 1.0,
                      ),
                      builder: (context, value, _) => LinearProgressIndicator(
                        value: value,
                        minHeight: 5,
                        backgroundColor: const Color(0xFFF4EAFF),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF6A1B9A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CONTEÚDO DESLIZANTE (ESTILO -> MEDIDAS)
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Navega pelos botões
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [_buildEstiloStep(), _buildMedidasStep()],
              ),
            ),

            // BOTÃO FIXO NO RODAPÉ
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A1B9A),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: const Color(0xFF6A1B9A).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _currentStep == 0 ? 'Próximo' : 'Pronto, criar conta',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ETAPA 1: SEU ESTILO E OBJETIVOS
  Widget _buildEstiloStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seu estilo',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'PlayfairDisplay',
              color: Color(0xFF2D1B36),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Quais estilos predominam na sua rotina?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),

          // CHIPS DE ESTILO (Padrão lilás igual aos de baixo)
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: _styles.map((style) {
              final isSelected = _selectedStyles.contains(style);
              return SelectablePill(
                text: style,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    isSelected
                        ? _selectedStyles.remove(style)
                        : _selectedStyles.add(style);
                  });
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 36),

          const Text(
            'Seus objetivos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'PlayfairDisplay',
              color: Color(0xFF2D1B36),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'O que você busca melhorar no seu guarda-roupa?',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // CHIPS DE OBJETIVOS
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: _objectives.map((objective) {
              final isSelected = _selectedObjectives.contains(objective);
              return SelectablePill(
                text: objective,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    isSelected
                        ? _selectedObjectives.remove(objective)
                        : _selectedObjectives.add(objective);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ETAPA 2: SUAS MEDIDAS E TAMANHO
  Widget _buildMedidasStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suas medidas',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'PlayfairDisplay',
              color: Color(0xFF2D1B36),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Para sugestões mais precisas de combinações e caimento.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 28),
          // GRADE DE MEDIDAS EDITÁVEIS
          Row(
            children: [
              Expanded(
                child: MeasureCard(
                  title: 'Busto',
                  unit: 'cm',
                  controller: _bustoCtrl,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MeasureCard(
                  title: 'Cintura',
                  unit: 'cm',
                  controller: _cinturaCtrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MeasureCard(
                  title: 'Quadril',
                  unit: 'cm',
                  controller: _quadrilCtrl,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MeasureCard(
                  title: 'Altura',
                  unit: 'm',
                  controller: _alturaCtrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tamanho padrão',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'PlayfairDisplay',
                  color: Color(0xFF2D1B36),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Modal de mais tamanhos
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF4EAFF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '+ Tamanhos',
                  style: TextStyle(
                    color: Color(0xFF6A1B9A),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _sizes.map((size) {
              final isSelected = _selectedSize == size;
              return GestureDetector(
                onTap: () => setState(() => _selectedSize = size),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6A1B9A)
                        : const Color(0xFFF4EAFF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF6A1B9A),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class SelectablePill extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const SelectablePill({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3C3FF) : const Color(0xFFF4EAFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF6A1B9A) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: const Color(0xFF6A1B9A),
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class MeasureCard extends StatelessWidget {
  final String title;
  final String unit;
  final TextEditingController controller;
  const MeasureCard({
    super.key,
    required this.title,
    required this.unit,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4EAFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(
                      color: Color(0xFF6A1B9A),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                unit,
                style: const TextStyle(
                  color: Color(0xFF6A1B9A),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
