import 'dart:async';

import 'package:firebase/model/postit.dart';
import 'package:firebase/pages/NewPostScreen.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(41.388422, 2.185971);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  final db = Firestore.instance;

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Sitio Chulo',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
    print(position.target);
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
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

    print("${location.latitude}, ${location.longitude}");
    return LatLng(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: StreamBuilder(
            stream: db.collection('postit').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              QuerySnapshot data = snapshot.data;
              List<DocumentSnapshot> docs = data.documents;
              List<Postit> lista = loadData(docs);
              for (var i = 0; i < lista.length; i++) {
                print(lista[i].descripcion);
              }
              return Stack(
                children: <Widget>[
                  //Expanded(flex: 1, child: Container(color: Colors.green,)),
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 10.0,
                    ),
                    mapType: _currentMapType,
                    markers: _markers,
                    onCameraMove: _onCameraMove,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
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
                            onPressed: () => _displayCurrentLocation(),
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
            }));
  }
}
