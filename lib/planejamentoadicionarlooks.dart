import 'package:flutter/material.dart';

class Planejamentoadicionarlooks extends StatelessWidget {
  final String dataSelecionada;

  const Planejamentoadicionarlooks ({super.key, required this.dataSelecionada});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planejar Look"),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "O que deseja fazer para o dia $dataSelecionada?",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Opção 1: Montar Look na hora
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              icon: const Icon(Icons.checkroom, size: 28), // Ou Icons.checkroom
              label: const Text("Montar look com peças do guarda-roupa", style: TextStyle(fontSize: 16)),
              onPressed: () {
                // TODO: Navegar para a sua tela de criação/combinação de peças
                debugPrint("Indo para montagem de look na hora...");
              },
            ),
            const SizedBox(height: 20),

            // Opção 2: Escolher look pronto
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.purple, width: 2),
                foregroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              icon: const Icon(Icons.photo_library, size: 28),
              label: const Text("Escolher um look já pronto", style: TextStyle(fontSize: 16)),
              onPressed: () {
                // TODO: Navegar para a sua galeria de looks salvos
                debugPrint("Indo para galeria de looks prontos...");
              },
            ),
          ],
        ),
      ),
    );
  }
}
