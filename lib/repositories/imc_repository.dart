
import 'package:hive/hive.dart';

import '../model/imc.dart';

class ImcRepository{
  static late Box _box;
  static late Box _box2;
ImcRepository._criar();


static Future<ImcRepository> carregar() async{

  if(Hive.isBoxOpen('configuracoes')){
    _box = Hive.box('configuracoes');

  }else{
    _box = await Hive.openBox('configuracoes');

  }

  if(Hive.isBoxOpen('historico')){
    _box2= Hive.box('historico');

  }else{
    _box2= await Hive.openBox('historico');

  }
  return ImcRepository._criar();
}

void salvar(Imc imc){
  _box.put(
    'configuracoes',{
    'nome_usuario': imc.nomeUsuario,
    'altura': imc.altura,
  });
}
Imc obterDados(){
  var configuracoes = _box.get('configuracoes');
  if(configuracoes == null){
    return Imc.vazio();

  }else{
    return Imc(configuracoes['nome_usuario'], configuracoes['altura']);

  }
}


  void salvarLista(double peso, double altura, String nome) {
    DateTime dataAtual = DateTime.now();
    int dia = dataAtual.day;
    int mes = dataAtual.month;
    int ano = dataAtual.year;
    String data = "$dia/$mes/$ano";
    String texto = '';

    double imc = peso / (altura * altura);

    if (imc < 16) {
      texto = 'Atenção, o seu IMC está em estado de magreza grave. Procure um médico imediatamente.';
    } else if (imc >= 16 && imc < 17) {
      texto = 'Atenção, o seu IMC está em estado de magreza moderada. Procure um médico.';
    } else if (imc >= 17 && imc < 18.5) {
      texto = 'Atenção, o seu IMC está em estado de magreza leve. Procure se alimentar.';
    } else if (imc >= 18.5 && imc < 25) {
      texto = 'Atenção, o seu IMC está em perfeito estado de saúde plena.';
    } else if (imc >= 25 && imc < 30) {
      texto = 'Atenção, o seu IMC está em estado de sobrepeso leve.';
    } else if (imc >= 30 && imc < 35) {
      texto = 'Atenção, o seu IMC está em estado de obesidade grau I. Procure um médico.';
    } else if (imc >= 35 && imc < 40) {
      texto = 'Atenção, o seu IMC está em estado de obesidade grau II (severa). Procure um médico.';
    } else if (imc >= 40) {
      texto = 'Atenção, o seu IMC está em estado de obesidade grau III (mórbida). Procure um médico.';
    }

    var historico = _box2.get('historico');
    if (historico == null) {
      historico = [
        {'texto': texto, 'data': data},
      ];
    } else {
      historico.add({'texto': texto, 'data': data});
    }

    _box2.put('historico', historico);
  }

List<dynamic>? obterLista() {
  var historico = _box2.get('historico');
  return historico;
}
}