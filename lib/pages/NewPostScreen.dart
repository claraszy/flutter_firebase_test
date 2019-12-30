//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewPostScreen extends StatefulWidget {
  LatLng posicion;
  NewPostScreen(this.posicion);

  @override
  _NewPostScreenState createState() => _NewPostScreenState(posicion);
}

class _NewPostScreenState extends State<NewPostScreen> {
  //TextEditingController _controller;
  List<TextEditingController> _controller;
  LatLng posicion;
  _NewPostScreenState(this.posicion);
  void initState() {
    //_controller = TextEditingController();
    _controller = [
      for (int i = 0; i < 3; i++) TextEditingController(),
    ];
    super.initState();
  }

  void dispose() {
    //_controller.dispose();
    for (int i = 0; i < 3; i++) _controller[i].dispose();

    super.dispose();
  }

  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post It'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Container(
              child: Text('Título'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: _controller[0],
              onSubmitted: (what) {
                //TODO
              },
              //keyboardType: TextInputType.number
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Container(child: Text('Descripción')),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _controller[1],
              onSubmitted: (what) {
                //TODO
              },
              //keyboardType: TextInputType.number
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Container(child: Text('Tags')),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _controller[2],
              onSubmitted: (what) {
                //TODO
              },
              //keyboardType: TextInputType.number
            ),
          ),
          /*Container(
            child: Text(this.posicion.toString()),
          )*/
          Expanded(flex: 5, child: Container()),
          Expanded(
              flex: 2,
              child: Container(
                color: Colors.grey,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 10,
                      child: Container(),
                    ),
                    IconButton(
                      icon: Icon(Icons.publish),
                      onPressed: () {
                        createPostit(posicion, _controller[0], _controller[1],
                                _controller[2])
                            .then((salida) {
                          //TODO
                          //Devolver la referencia y añadir al usuario que ha hecho el upload
                          print(salida);
                          Navigator.of(context).pop(salida);
                        });
                      },
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  createPostit(coordenadas, titulo, descripcion, tags) async {
    /*await db.collection("postit").document("1").setData({
      'title': 'Mastering Flutter',
      'description': 'Programming Guide for Dart'
    });*/
    print(coordenadas);
    print(titulo.text);
    print(descripcion.text);
    print(tags.text);
    DocumentReference ref = await db.collection("postit").add({
      'title': titulo.text,
      'description': descripcion.text,
      'caducidad': DateTime.fromMicrosecondsSinceEpoch(
          DateTime.now().microsecondsSinceEpoch + 604800000000),
      'coordenadas': GeoPoint(coordenadas.latitude, coordenadas.longitude),
      //GeoPoint(41.564191, 2.017206),
      'valoraciones': 0,
    });

    await db
        .collection("postit")
        .document(ref.documentID)
        .collection("tags")
        .add({'tag': tags.text});

    return ref.documentID;
  }
}
