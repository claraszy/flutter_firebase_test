
class Perfil {
  String _alias, _email, _foto, _nombre;
  int _nPublicaciones, _nValoraciones;
  List _pGustados, _pVigentes;

  Perfil(this._alias, this._email, this._foto, this._nombre, this._nPublicaciones, this._nValoraciones, this._pGustados, this._pVigentes);
 
  get alias => _alias;
  get email => _email;
  get foto => _foto;
  get nombre => _nombre;
  get nPublicaciones => _nPublicaciones;
  get nValoraciones => _nValoraciones;
  get pGustados => _pGustados;
  get pVigentes => _pVigentes;
}
