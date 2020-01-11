import 'dart:async';

import 'package:firebase/model/postit.dart';
import 'package:firebase/pages/ProfileScreen.dart';
import 'package:firebase/pages/TrendingScreen.dart';
import 'package:firebase/services/authentification.dart';
import 'package:firebase/widgets/Drawer.dart';
import 'package:firebase/pages/NewPostScreen.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geohash/geohash.dart';

class MapScreen extends StatefulWidget {
  MapScreen(this.location, final String userId,
      {Key key, this.auth, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  String userId;
  LatLng location;
  @override
  _MapScreenState createState() => _MapScreenState(this.location, this.userId);
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  _MapScreenState(this._center, this.userIdMV);

  LatLng _center;

  String userIdMV;
  String user_id = '';
  final Set<Marker> _markers = {};

  //LatLng _lastMapPosition = LatLng(41.5640083, 2.0224067000000048);

  MapType _currentMapType = MapType.normal;

  bool visible = false;

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
    //print('LLego al init');
  }

  void _refresh(
      lista_actual, lista_anterior, geohash_actual, geohash_anterior, visible) {
    //print('Hola');
    if (visible &&
        geohash_actual != geohash_anterior &&
        lista_actual != lista_anterior) {
      setState(() {
        _markers.clear();
      });
      for (var i = 0; i < lista_actual.length; i++) {
        String descripcion = lista_actual[i].descripcion;
        //print(descripcion);
        String titulo = lista_actual[i].titulo;
        //print(titulo);
        var valoracion = lista_actual[i].valoraciones;
        //print(valoracion);
        List<String> tags = ["tags"];

        _markers.add(Marker(
            // This marker id can be anything that uniquely identifies each marker.
            //TODO
            //Cambiar identificador, para que sea único.
            markerId: MarkerId(i.toString()),
            position: lista_actual[i].posicion,
            icon: BitmapDescriptor.defaultMarker,
            onTap: () {
              print('Tap');
              showFancyCustomDialog(
                  context, titulo, descripcion, valoracion, tags);
            }));
      }

      lista_anterior = geohash_actual;
      geohash_anterior = lista_actual;
    }
  }

  void _onAddMarkerButtonPressed(lista_entrada, lista2, visible) {
    //print('Adding marks');
    if (visible) {
      setState(() {
        for (var i = 0; i < lista_entrada.length; i++) {
          String descripcion = lista_entrada[i].descripcion;
          //print(descripcion);
          String titulo = lista_entrada[i].titulo;
          //print(titulo);
          var valoracion = lista_entrada[i].valoraciones;
          //print(valoracion);
          List<String> tags = ["tags"];

          _markers.add(Marker(
              // This marker id can be anything that uniquely identifies each marker.
              //TODO
              //Cambiar identificador, para que sea único.
              markerId: MarkerId(i.toString()),
              position: lista_entrada[i].posicion,
              icon: BitmapDescriptor.defaultMarker,
              onTap: () {
                print('Tap');
                showFancyCustomDialog(
                    context, titulo, descripcion, valoracion, tags);
              }));
        }

        lista2 = lista_entrada;
      });
    } else {
      setState(() {
        _markers.clear();
      });
    }
  }

  void _onCameraMove(CameraPosition position) {
    /*if (_lastMapPosition != position.target) {
      print('Se mueve!');
    } */

    //_lastMapPosition = position.target;

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
  void _onItemTapped(int index) {
    if (index == 1) {
      print('userIdMV');
      print(userIdMV);
      print(user_id);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrendingScreen(this.user_id),
        ),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileScreen(this.user_id),
        ),
      );
    }
    setState(() {
      ///////// Cuando tengamos las otras dos páginas, establecemos aquí las rutas
      _selectedIndex = index;
    });
  }

  String my_geohash = 'Null';
  String my_geohash_anterior = 'Null';
  GoogleMapController _controller_mapa;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.grey);

  Future<void> move_move() async {
    double lat = _center.latitude;
    double long = _center.longitude;
    GoogleMapController controller = await _controller.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 17.7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Maps Sample App'),
        backgroundColor: Colors.teal[900],
      ),
      drawer: drawer(),
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
            title: Text("TENDENCIAS"),
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
      body: StreamBuilder(
        stream: db
            .collection('postit')
            .where('geohash', isEqualTo: my_geohash)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //print('userIdMV');
          //print(userIdMV);
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> docs = data.documents;
          List<Postit> lista = loadData(docs);
          //print('---------------------');
          if (userIdMV != null && user_id == '') {
            user_id = userIdMV;
          }
          //print('---------------------');
          //print('Fine');
          _displayCurrentLocation().then((salida) {
            setState(() {
              my_geohash = Geohash.encode(salida.latitude, salida.longitude)
                  .substring(0, 7);
              //print(my_geohash);
              _center = salida;
              //geohash_actual, geohash_anterior
              _refresh(lista, lista2, my_geohash, my_geohash_anterior, visible);
            });
            //print('Geohash');
            // print(Geohash.encode(my_geohash.latitude, my_geohash.longitude).substring(0, 7));
            //print('Hola');
          });

          move_move();
          //print("Centrooo");
          //print(_center);
          //print(my_geohash);
          return Stack(
            children: <Widget>[
              //Expanded(flex: 1, child: Container(color: Colors.green,)),
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 17.7,
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
                        onPressed: () {
                          //visible
                          setState(() {
                            visible = !visible;
                          });
                          _onAddMarkerButtonPressed(lista, lista2, visible);
                        },
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

void showFancyCustomDialog(
    BuildContext context, titulo, descripcion, valoracion, tags) {
  //List<String> tags = ['300', '111', '222', '3333', '444'];
  Dialog fancyDialog = Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: 300.0,
      width: 300.0,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          Container(
            //width: double.infinity,
            height: 50,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Colors.teal[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                titulo,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 8, right: 8),
            child: Container(
              height: 150,
              child: ListView(children: <Widget>[
                Center(
                    child: Text('Descripcion',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ))),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                    child: Text(descripcion),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.grey[100],
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      width: 150,
                      height: 5,
                      child: Center(
                        child: ListTile(
                          leading: Center(
                              widthFactor: 1,
                              heightFactor: 1,
                              child: Text(
                                '# ' + tags[index].toString(),
                                overflow: TextOverflow.clip,
                              )),

                          //title: Text('#${tags[index]}', style: TextStyle(fontSize: 12),),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "-",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  //color: Colors.grey,
                  child: Text(valoracion.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    bottom: 8.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "+",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment(1.05, -1.05),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  showDialog(context: context, builder: (BuildContext context) => fancyDialog);
}
