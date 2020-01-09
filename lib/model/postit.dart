import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Postit {
  String _titulo;
  GeoPoint _posicion;
  String _descripcion;
  int _valoraciones;
  Timestamp _caducidad;
  String _geohash;
  List <String> _tags;
  bool _oculto;

  Postit(this._titulo, this._posicion, this._descripcion, this._valoraciones,
      this._caducidad, this._geohash, this._tags, this._oculto);

  get posicion => LatLng(_posicion.latitude, _posicion.longitude);
  get valoraciones => _valoraciones;
  get titulo => _titulo;
  get descripcion => _descripcion;
  get caducidad => _caducidad;
  get geohash => _geohash;
  get tags => _tags;
  get oculto => _oculto;
}
