import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/imc.dart';
import '../repositories/imc_repository.dart';

class PaginaConfiguracoes extends StatefulWidget {
  const PaginaConfiguracoes({Key? key}) : super(key: key);

  @override
  _PaginaConfiguracoesState createState() => _PaginaConfiguracoesState();
}

class _PaginaConfiguracoesState extends State<PaginaConfiguracoes> {
  late ImcRepository imcRepository;
  Imc imc = Imc.vazio();
  TextEditingController _nome_controller = TextEditingController();
  TextEditingController _altura_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    imcRepository = await ImcRepository.carregar();
    imc = imcRepository.obterDados();
    setState(() {
      _nome_controller.text = imc.nomeUsuario;
      _altura_controller.text = imc.altura.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Página Inicial'),
              onTap: () {
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: TextField(
                        controller: _nome_controller,
                        decoration: const InputDecoration(
                          labelText: 'Digite o seu nome',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          //Aqui você pode realizar ações com o texto inserido
                          print('Texto inserido: $value');
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: TextField(
                        controller: _altura_controller,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\.?\d{0,2}')),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Digite a sua altura',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          //Aqui você pode realizar ações com o texto inserido
                          print('Texto inserido: $value');
                        },
                      ),

                    ),

                  ),
                  Center(
                    child: TextButton(
                            onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            try {
                             imc.altura =
                              double.parse(_altura_controller.text);
                              imc.nomeUsuario = _nome_controller.text;
                              imcRepository.salvar(imc);

                            } catch (e) {
                              showDialog(
                              context: context,
                              builder: (_) {
                              return AlertDialog(
                                title: Text("Meu App"),
                                content:
                                Text("Favor informar uma altura válida!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      },
                                  child: Text("Ok"))
                                  ],
                              );
                            });
                            return;
                          }
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/');

                          },
                          child: Text("Salvar")),
                  ),
                ],
              ),

            ),
          ]
         ),
    ),
    );


  }
}
