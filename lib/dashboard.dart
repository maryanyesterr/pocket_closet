import 'package:flutter/material.dart';
import 'package:pocket_closet/home.dart';
import 'package:pocket_closet/guardaroupa.dart';
import 'package:pocket_closet/meuslooks.dart';
import 'package:pocket_closet/planejamento.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  // Atalho estático opcional para mudar de aba em qualquer lugar do app de forma limpa
  static _DashboardState? of(BuildContext context) =>
      context.findAncestorStateOfType<_DashboardState>();

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  // Função pública para que as outras telas consigam mudar a aba dinamicamente
  void mudarAba(int novoIndice) {
    setState(() {
      _currentIndex = novoIndice;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lista de telas injetando a função de mudar de aba caso queira usar via construtor
    final List<Widget> _telas = [
      const Home(),
      const GuardaRoupa(),
      const MeusLooks(),
      const PlanejamentoSemanal(),
    ];

    return Scaffold(
      // O IndexedStack mantém o estado de digitação/filtros salvos ao alternar de aba
      body: IndexedStack(
        index: _currentIndex,
        children: _telas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromRGBO(81, 17, 147, 1),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: mudarAba, // Chama a função dinamicamente
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.door_sliding_outlined),
            activeIcon: Icon(Icons.door_sliding),
            label: 'Guarda-roupa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom_outlined),
            activeIcon: Icon(Icons.checkroom),
            label: 'Looks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Planejamento',
          ),
        ],
      ),
    );
  }
}
