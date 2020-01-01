import 'dart:async';

import 'package:firebase/model/postit.dart';
import 'package:firebase/pages/NewPostScreen.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geohash/geohash.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng _center = LatLng(41.5640083, 2.0224067000000048);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = LatLng(41.5640083, 2.0224067000000048);

  MapType _currentMapType = MapType.normal;

  final db = Firestore.instance;
  final lista2 = [];
  GoogleMapController mapController;
  void initstate() {
    super.initState();
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _center.latitude,
            _center.longitude,
          ),
        ),
      ),
    );
    print('LLego al init');
  }

  void _onAddMarkerButtonPressed(lista_entrada, lista_anterior) {
    print('Adding marks');
    if (lista_entrada != lista_anterior) {
      setState(() {
        for (var i = 0; i < lista_entrada.length; i++) {
          _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            //TODO
            //Cambiar identificador, para que sea único.
            markerId: MarkerId(lista_entrada[i].posicion.toString()),
            position: lista_entrada[i].posicion,
            infoWindow: InfoWindow(
              title: lista_entrada[i].descripcion,
              snippet: lista_entrada[i].valoraciones.toString(),
            ),
            icon: BitmapDescriptor.defaultMarker,
          ));
        }
        lista_entrada = lista_anterior;
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    if (_lastMapPosition != position.target) {
      print('Se mueve!');
    }
    _lastMapPosition = position.target;

    //print(position.target);
    //TODO
    //Se debería de explotar un poco mas esta funcionalidad
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    //mapController = controller;
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<LatLng> _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //print("${location.latitude}, ${location.longitude}");

    //print(_geohash.substring(0, 7));
    return LatLng(location.latitude, location.longitude);
  }

  ///Bottom Navigation Bar definición de elementos
  int _selectedIndex = 0;
  String my_geohash = 'Null';
  GoogleMapController _controller_mapa;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey);
  void _onItemTapped(int index) {
    setState(() {
      ///////// Cuando tengamos las otras dos páginas, establecemos aquí las rutas
      _selectedIndex = index;
    });
  }

  Future<void> move_move() async {
    print('Almenos paso por aqui');

    double lat = _center.latitude;
    double long = _center.longitude;
    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 20.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample App'),
        backgroundColor: Colors.teal[900],
      ),
      drawer: _drawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal[900],
        iconSize: 20,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text("MAPA"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            title: Text("FAVORITOS"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("PERFIL"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent[400],
        onTap: _onItemTapped,
      ),
      ////

      body: StreamBuilder(
        stream: db
            .collection('postit')
            .where('geohash', isEqualTo: my_geohash)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print('Inicio');
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> docs = data.documents;
          List<Postit> lista = loadData(docs);
          print('---------------------');

          print('---------------------');
          print('Fine');
          _displayCurrentLocation().then((salida) {
            setState(() {
              my_geohash = Geohash.encode(salida.latitude, salida.longitude)
                  .substring(0, 7);
              _center = salida;
            });
            //print('Geohash');
            // print(Geohash.encode(my_geohash.latitude, my_geohash.longitude).substring(0, 7));
            //print('Hola');
          });
          move_move();
          print("Centrooo");
          print(_center);
          print(my_geohash);
          return Stack(
            children: <Widget>[
              //Expanded(flex: 1, child: Container(color: Colors.green,)),
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 20.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
                myLocationEnabled: true,
                rotateGesturesEnabled: false,
                scrollGesturesEnabled: false,
                zoomGesturesEnabled: false,
                tiltGesturesEnabled: false,
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 36,
                      ),
                      FloatingActionButton(
                        heroTag: 'btn1',
                        onPressed: _onMapTypeButtonPressed,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.grey,
                        child: const Icon(Icons.map, size: 36.0),
                      ),
                      //height: 16.0
                      FloatingActionButton(
                        heroTag: 'btn2',
                        //onPressed: () => _onAddMarkerButtonPressed(),
                        onPressed: () {
                          _displayCurrentLocation().then((salida) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NewPostScreen(salida),
                              ),
                            );
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.grey,
                        child: const Icon(Icons.add_location, size: 36.0),
                      ),
                      FloatingActionButton(
                        heroTag: 'btn3',
                        onPressed: () =>
                            _onAddMarkerButtonPressed(lista, lista2),
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.satellite, size: 36.0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _drawer() {
  //TODO
  //Pasar por parametro los TAGS que hayan en este Geohash
  List<String> lista = ['Enano', 'Android', 'Fiesta'];
  return Drawer(
      elevation: 16.0,
      child: ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {},
          child: ListTile(
            title: Text("#" + lista[index]),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      ));
}
