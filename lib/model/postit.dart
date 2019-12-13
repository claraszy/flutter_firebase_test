import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Postit {
  GeoPoint coordenadas;
  String descripcion;
  int valoraciones;
  Timestamp caducidad;

  Postit(this.coordenadas, this.descripcion, this.valoraciones, this.caducidad);

  LatLng getlatlong() => LatLng(this.coordenadas.latitude, this.coordenadas.longitude);
}
