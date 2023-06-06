import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_imc_dio_hive/pages/pagina_inicial.dart';
import 'package:my_imc_dio_hive/pages/pagina_configuracoes.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var documentsDirectory = await getApplicationDocumentsDirectory();

  Hive.init(documentsDirectory.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Aplicação',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => PaginaInicial() , // Use o widget PaginaInicial
        '/configuracoes': (context) => PaginaConfiguracoes(),
      },
    );
  }
}

