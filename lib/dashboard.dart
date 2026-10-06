import 'package:flutter/material.dart';
import 'package:pocket_closet/home.dart';
import 'package:pocket_closet/guardaroupa.dart';
import 'package:pocket_closet/meuslooks.dart';
import 'package:pocket_closet/planejamento.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Controla o índice da aba ativa
  int _currentIndex = 0;

  // Lista ordenada com as 4 telas principais do seu app
  final List<Widget> _telas = [
    const Home(),
    const GuardaRoupa(),
    const MeusLooks(),
    const PlanejamentoSemanal(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // renderiza dinamicamente a tela selecionada
      body: IndexedStack(
        index: _currentIndex,
        children: _telas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromRGBO(81, 17, 147, 1), // Roxo do seu app
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Altera a aba dinamicamente
          });
        },
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
