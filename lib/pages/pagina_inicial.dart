import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/imc.dart';
import '../repositories/imc_repository.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({Key? key}) : super(key: key);

  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}
class _PaginaInicialState extends State<PaginaInicial> {
  late ImcRepository imcRepository;
  Imc imc = Imc.vazio();
  String _nome = '';
  double _altura = 0.00;
  ScrollController _scrollController = ScrollController();
  String _texto= '';
  String _data= '';

  TextEditingController _peso_controller= TextEditingController();
List historico = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    imcRepository = await ImcRepository.carregar();
    setState(() {
      imc = imcRepository.obterDados();

      historico = imcRepository.obterLista()!;
      _nome = imc.nomeUsuario;
      _altura = imc.altura;
    });

  }

  @override
  Widget build(BuildContext context) {
    List<Widget> viewHome= [];
    imc = imcRepository.obterDados();
    setState(() {
      _nome = imc.nomeUsuario;
      _altura = imc.altura;
    });

    if (_nome != null && _altura != 0.00) {
      viewHome.addAll([
        Container(
          margin: EdgeInsets.only(top: 150.0, left: 16.0, right: 16.0),
          child: Text(
            'Olá $_nome, a sua altura atual é $_altura',
            style: TextStyle(fontSize: 24),
          ),
        ),
        SizedBox(height: 20.0), // Espaçamento entre os elementos
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _peso_controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\.?\d{0,2}')),
            ],
            decoration: const InputDecoration(
              labelText: 'Digite o seu peso',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              //Aqui você pode realizar ações com o texto inserido
              print('Texto inserido: $value');
            },
          ),
        ),
        SizedBox(height: 20.0), // Espaçamento entre os elementos
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          width: double.infinity, // Define o width como 100%
          child: ElevatedButton(
            onPressed: () async {
              try {
                imcRepository.salvarLista(
                  double.parse(_peso_controller.text),
                  _altura,
                  _nome,
                );

                setState(() {
                  historico = imcRepository.obterLista()!;
                  _peso_controller.text ="";
                });
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 500), // Duração da animação
                  curve: Curves.ease, // Curva de animação
                );
                print('Dados salvos com sucesso!');
              } catch (e) {
                print('Erro ao salvar os dados: $e');
              }


              print('Dados salvos com sucesso!');
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Cor de fundo do botão
            ),
            child: Text(
              "Calcular IMC",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 0.0), // Espaçamento entre os elementos
        Expanded(
          child: ListView.separated(
            controller: _scrollController, // Adicione o controlador ao ListView
            itemCount: historico.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              final item = historico[index];
              _texto = item['texto'];
              _data = item['data'];

              return ListTile(
                title: Text(_texto),
                subtitle: Text(_data.toString()),
              );
            },
          ),
        ),
      ]);

    } else {
      viewHome.addAll([
        Container(
          margin: EdgeInsets.only(top: 250.0, left: 16.0, right: 16.0),
          child:  Center(
            child: Text(
              "Para $_nome $_altura iniciar vamos às configurações, definir os dados principais",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/configuracoes');
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // Cor de fundo do botão
          ),
          child: Text("Configurações",
           style: TextStyle(color: Colors.white),

    ),
        ),
      ]);
    }

   return Scaffold(
      appBar: AppBar(
        title: Text('Página Inicial'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Configurações'),
              onTap: () {
                Navigator.pop(context);

                Navigator.pushNamed(context, '/configuracoes');

              },
            ),
          ],
        ),
      ),
      body: Center(

        child: Column(
          children: viewHome
        ),
      ),
    );
  }
}
