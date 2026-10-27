import 'package:flutter/material.dart';
import 'package:pocket_closet/planejamentoadicionarlooks.dart';
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
  
  final Map<String, List<String>> looksPorData = {};

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
        child: SingleChildScrollView(
          // <-- 1. Adicionado para permitir rolagem se o teclado ou calendário mensal abrir
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
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
                // CALENDÁRIO AUTOMÁTICO
                // ==================================================
                TableCalendar(
                  locale: 'pt_BR',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _diaFocado,
                  calendarFormat: _formatoCalendario,
                  selectedDayPredicate: (day) =>
                      isSameDay(_diaSelecionado, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _diaSelecionado = selectedDay;
                      _diaFocado = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _diaFocado = focusedDay;
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
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
                      color: Colors.purple.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: const TextStyle(color: Colors.black87),
                    weekendTextStyle: const TextStyle(color: Colors.redAccent),
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

                // 2. Removido o 'Expanded' e trocado por uma renderização condicional direta
                pecasDoDiaAtual.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40.0,
                        ), // Garante um espaçamento confortável
                        child: Center(
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
                        ),
                      )
                    : Container(
                        // 3. Definido uma altura máxima/padrão para o GridView não quebrar dentro do scroll
                        constraints: const BoxConstraints(maxHeight: 260),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F4F0),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.amber.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: GridView.builder(
                          shrinkWrap: true, // <-- Importante para funcionar dentro do SingleChildScrollView
                          physics: const ClampingScrollPhysics(), // Scroll suave interno se necessário
                          itemCount: pecasDoDiaAtual.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
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

                // ==================================================
                // BOTÃO INFERIOR (+) PARA ADICIONAR LOOK NA DATA ATIVA
                // ==================================================
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Planejamentoadicionarlooks(
                              dataSelecionada: chaveDataAtual,
                            ),
                          ),
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
      ),
    );
  }
}
