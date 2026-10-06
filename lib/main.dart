import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pocket_closet/cadastro.dart';
import 'package:pocket_closet/criarlooks.dart';
import 'package:pocket_closet/dashboard.dart';
import 'package:pocket_closet/guardaroupa.dart';
import 'package:pocket_closet/home.dart';
import 'package:pocket_closet/login.dart';
import 'package:pocket_closet/meuslooks.dart';
import 'package:pocket_closet/planejamento.dart';
import 'package:pocket_closet/seuestilo.dart';
import 'package:pocket_closet/suasMedidas.dart';

void main() {
  // 2. Garante que os bindings do Flutter estejam prontos antes de rodar o código assíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // 3. Inicializa os dados de data para o Brasil (pt_BR)
  initializeDateFormatting('pt_BR', null).then((_) {
    // Só inicia o app depois que a tradução estiver carregada com sucesso
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Closet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Dashboard(),
    );
  }
}
