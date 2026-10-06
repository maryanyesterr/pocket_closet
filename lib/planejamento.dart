import 'package:flutter/material.dart';
// Importação do pacote de calendário automatizado
import 'package:table_calendar/table_calendar.dart';

class PlanejamentoSemanal extends StatefulWidget {
  const PlanejamentoSemanal({super.key});

  @override
  State<PlanejamentoSemanal> createState() => _PlanejamentoSemanalState();
}

class _PlanejamentoSemanalState extends State<PlanejamentoSemanal> {
  // Configura a visualização padrão para mostrar apenas a linha da semana atual (7 dias)
  CalendarFormat _formatoCalendario = CalendarFormat.week;

  // Guarda o dia focado/atual do sistema
  DateTime _diaFocado = DateTime.now();

  // Guarda qual dia o usuário clicou fisicamente na barra
  DateTime? _diaSelecionado;

  // Banco de dados simulado e indexado por datas reais (Ano-Mês-Dia) para automação perfeita
  final Map<String, List<String>> looksPorData = {
    "2026-05-13": [
      'assets/img/blusa_bege.png',
      'assets/img/jeans_claro.png',
      'assets/img/tenis_branco.png',
      'assets/img/bolsa_marrom.png',
    ],
    "2026-05-14": [
      'assets/img/jaqueta_azul.png',
      'assets/img/jeans_claro.png',
      'assets/img/chapeu_bege.png',
    ],
    "2026-05-15": [
      'assets/img/vestido_preto.png',
      'assets/img/oculos_escuros.png',
      'assets/img/tenis_branco.png',
    ],
    "2026-05-16": [
      'assets/img/casaco_bege.png',
      'assets/img/jeans_claro.png',
      'assets/img/oculos_escuros.png',
    ],
  };

  @override
  void initState() {
    super.initState();
    // Inicializa marcando o dia de hoje como o selecionado na abertura do app
    _diaSelecionado = _diaFocado;
  }

  // Função auxiliar automatizada que converte qualquer DateTime para o formato texto "AAAA-MM-DD"
  String _formatarDataChave(DateTime data) {
    return "${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    // Busca a lista de roupas cadastradas para o dia clicado. Se não houver nada, retorna uma lista vazia.
    final String chaveDataAtual = _formatarDataChave(
      _diaSelecionado ?? _diaFocado,
    );
    final List<String> pecasDoDiaAtual = looksPorData[chaveDataAtual] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TOPO: TÍTULO E BOTÃO DE VOLTAR
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    SizedBox(
                    width: 60,
                    height: 60,
                    child: Image.asset("assets/imgs/logo.png"),
                  ),
                  const Text(
                    "Planejamento semanal",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Botão para alternar a visualização entre o formato de Semana ou Mês inteiro
                  IconButton(
                    icon: Icon(
                      _formatoCalendario == CalendarFormat.week
                          ? Icons.calendar_view_month
                          : Icons.calendar_view_week,
                      color: Colors.purple,
                    ),
                    onPressed: () {
                      setState(() {
                        _formatoCalendario =
                            _formatoCalendario == CalendarFormat.week
                            ? CalendarFormat.month
                            : CalendarFormat.week;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ==================================================
              // CALENDÁRIO AUTOMÁTICO (Substitui o antigo seletor fixo)
              // ==================================================
              TableCalendar(
                locale:
                    'pt_BR', // Deixa os meses e dias em português brasileiro
                firstDay: DateTime.utc(
                  2020,
                  1,
                  1,
                ), // Limite passado do calendário
                lastDay: DateTime.utc(
                  2030,
                  12,
                  31,
                ), // Limite futuro do calendário
                focusedDay: _diaFocado,
                calendarFormat: _formatoCalendario,
                selectedDayPredicate: (day) => isSameDay(_diaSelecionado, day),

                // Disparado automaticamente quando o usuário clica em qualquer dia da barra
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _diaSelecionado = selectedDay;
                    _diaFocado = focusedDay; // Atualiza o foco visual para o mês/semana correspondente
                  });
                },

                // Permite mudar de semana/mês arrastando o dedo para os lados
                onPageChanged: (focusedDay) {
                  _diaFocado = focusedDay;
                },

                // Estilização visual para combinar com a identidade roxa do seu app
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false, // Esconde o botão padrão de mudar formato do pacote
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  leftChevronIcon: Icon(
                    Icons.arrow_back_ios,
                    size: 16,
                    color: Colors.black,
                  ),
                  rightChevronIcon: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.purple.withOpacity(
                      0.3,
                    ), // Destaque suave no dia real de hoje
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors
                        .purple, // Círculo roxo no dia selecionado pelo usuário
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  defaultTextStyle: const TextStyle(color: Colors.black87),
                  weekendTextStyle: const TextStyle(
                    color: Colors.redAccent,
                  ), // Fins de semana com cor diferenciada
                ),
              ),
              const SizedBox(height: 25),

              // ==================================================
              // CONTAINER AUTOMATIZADO DO LOOK DO DIA SELECIONADO
              // ==================================================
              const Text(
                "Look agendado para o dia:",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: pecasDoDiaAtual.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Nenhum look planejado para esta data.",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFF7F4F0,
                          ), // Fundo bege suave do seu design
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.amber.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: GridView.builder(
                          itemCount: pecasDoDiaAtual.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Exibe as peças em quadrantes 2x2 para destaque
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemBuilder: (context, itemIndex) {
                            return Center(
                              child: Image.asset(
                                pecasDoDiaAtual[itemIndex],
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.checkroom,
                                    size: 40,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ),

              // ==================================================
              // BOTÃO INFERIOR (+) PARA ADICIONAR LOOK NA DATA ATIVA
              // ==================================================
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      // Automatizado: Sabe exatamente em qual data o usuário quer inserir o look
                      debugPrint(
                        "Abrindo criador de looks para a data: $chaveDataAtual",
                      );
                    },
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.purple,
                        size: 32,
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
