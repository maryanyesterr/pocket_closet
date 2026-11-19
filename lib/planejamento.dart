import 'package:flutter/material.dart';
import 'package:pocket_closet/planejamentoadicionarlooks.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

class PlanejamentoSemanal extends StatefulWidget {
  const PlanejamentoSemanal({super.key});

  @override
  State<PlanejamentoSemanal> createState() => _PlanejamentoSemanalState();
}

class _PlanejamentoSemanalState extends State<PlanejamentoSemanal> {
  CalendarFormat _formatoCalendario = CalendarFormat.week;
  DateTime _diaFocado = DateTime.now();
  DateTime? _diaSelecionado;

  @override
  void initState() {
    super.initState();
    _diaSelecionado = _diaFocado;
  }

  String _formatarDataChave(DateTime data) {
    return "${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final String chaveDataAtual = _formatarDataChave(_diaSelecionado ?? _diaFocado);
    
    // ACESSA O HIVE PARA BUSCAR OS LOOKS SALVOS DESTA DATA
    final box = Hive.box('looksBox');
    final List<dynamic> pecasDinamicas = box.get(chaveDataAtual, defaultValue: []);
    final List<String> pecasDoDiaAtual = List<String>.from(pecasDinamicas);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TOPO: TÍTULO E LOGO
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
                      "Planejamento",
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
                          _formatoCalendario = _formatoCalendario == CalendarFormat.week
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
                  selectedDayPredicate: (day) => isSameDay(_diaSelecionado, day),
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
                    titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    leftChevronIcon: Icon(Icons.arrow_back_ios, size: 16, color: Colors.black),
                    rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
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
                    selectedTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    defaultTextStyle: const TextStyle(color: Colors.black87),
                    weekendTextStyle: const TextStyle(color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 25),

                // ==================================================
                // CONTEÚDO DOS LOOKS AGENDADOS
                // ==================================================
                const Text(
                  "Look agendado para o dia:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 10),

                pecasDoDiaAtual.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.event_busy, size: 50, color: Colors.grey.shade400),
                              const SizedBox(height: 10),
                              const Text(
                                "Nenhum look planejado para esta data.",
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        constraints: const BoxConstraints(maxHeight: 260),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F4F0),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber.shade200, width: 1.5),
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: pecasDoDiaAtual.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  return const Icon(Icons.checkroom, size: 40, color: Colors.grey);
                                },
                              ),
                            );
                          },
                        ),
                      ),

                // ==================================================
                // BOTÃO (+) ADICIONAR LOOK (Ao voltar das telas ele atualiza)
                // ==================================================
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: GestureDetector(
                      onTap: () async {
                        // O 'await' faz esperar o usuário retornar da tela de adicionar...
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Planejamentoadicionarlooks(
                              dataSelecionada: chaveDataAtual,
                            ),
                          ),
                        );
                        // ...e quando ele voltar, atualiza a tela do calendário automaticamente!
                        setState(() {});
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
                        child: const Icon(Icons.add, color: Colors.purple, size: 32),
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
