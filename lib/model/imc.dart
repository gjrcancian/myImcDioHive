class Imc{

  String _nomeUsuario = "";
  double _altura = 0;
  Imc.vazio(){
    _nomeUsuario ="";
    _altura = 0;
  }
  Imc(this._nomeUsuario, this._altura);
  String get nomeUsuario => _nomeUsuario;
  set nomeUsuario(String nome_usuario){
    _nomeUsuario = nome_usuario;
  }
  double get altura => _altura;
  set altura(double altura){
    _altura = altura;
  }
}
