

class Perfil {
  String alias, email, foto, nombre;
  int nPublicaciones, nValoraciones;
  List pGustados, pVigentes;

  Perfil(this.alias, this.email, this.foto, this.nombre, this.nPublicaciones, this.nValoraciones, this.pGustados, this.pVigentes);
 
  get alias => _alias;
  get email => _email;
  get foto => _foto;
  get nombre => _nombre;
  get nPublicaciones => _nPublicaciones;
  get nValoraciones => _nValoraciones;
  get pGustados => _pGustados;
  get pVigentes => _pVigentes;
}
