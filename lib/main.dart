import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pocket_closet/dashboard.dart';
import 'package:hive_flutter/hive_flutter.dart'; // <-- 1. Faltava importar isso aqui no topo!

// 2. Adicionado o 'async' bem aqui na função main
void main() async { 
  // Garante que os bindings do Flutter estejam prontos antes de rodar o código assíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Inicializa o Hive localmente antes de carregar as datas
  await Hive.initFlutter();
  await Hive.openBox('looksBox');

  // 4. Inicializa os dados de data para o Brasil (pt_BR) e abre o app
  initializeDateFormatting('pt_BR', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Closet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Correção de sintaxe pequena que havia no seu arquivo original (ColorScheme.fromSeed)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Dashboard(),
    );
  }
}
