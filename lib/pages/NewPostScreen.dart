import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/widgets/TagRow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geohash/geohash.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewPostScreen extends StatefulWidget {
  LatLng posicion;
  NewPostScreen(this.posicion);

  @override
  _NewPostScreenState createState() => _NewPostScreenState(posicion);
}

class _NewPostScreenState extends State<NewPostScreen> {
  List<TextEditingController> _controller;
  List<String> tags = [];
  String etiqueta;
  LatLng posicion;
  bool ocult = false;
  _NewPostScreenState(this.posicion);
  void initState() {
    _controller = [
      for (int i = 0; i < 3; i++) TextEditingController(),
    ];
    super.initState();
  }

  void dispose() {
    for (int i = 0; i < 3; i++) _controller[i].dispose();
    super.dispose();
  }

  final db = Firestore.instance;
  final focus = FocusNode();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, top: 30.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: Text(
                            "new post it",
                            style: TextStyle(fontSize: 30, color: Colors.teal),
                          ),
                        ),
                        Spacer(),
                        Container(
                          child: FlatButton(
                            child: Icon(
                              Icons.thumbs_up_down,
                              color: (ocult ? Colors.grey[800] : Colors.teal),
                            ),
                            onPressed: () {},
                            onLongPress: () {
                              setState(() {
                                ocult = !ocult;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: Text(
                      'Title',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                    controller: _controller[0],
                    onSubmitted: (what) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: Text(
                      'Description',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      focusNode: focus,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: null,
                      minLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[300],
                      ),
                      controller: _controller[1],
                      onSubmitted: (what) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: Text(
                      '#tags',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[300],
                    ),
                    controller: _controller[2],
                    onSubmitted: (what) {
                      etiqueta = _controller[2].text.toString();
                      setState(() {
                        tags.add(etiqueta);
                      });
                      _controller[2].clear();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: TagRow(tags: tags),
                  ),
                ],
              ),
            ),
          ),
          /*Container(
                                child: Text(this.posicion.toString()),
                                 )*/
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              color: Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 50),
                    child: IconButton(
                      hoverColor: Colors.red[900],
                      tooltip: 'Cancel',
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[700],
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Divider(
                    thickness: 10,
                    color: Colors.grey[300],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 60.0, left: 55),
                    child: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.teal,
                          size: 25,
                        ),
                        onPressed: () {
                          if (_controller[0].text.isEmpty ||
                              _controller[1].text.isEmpty ||
                              tags.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Icon(Icons.warning),
                                      content: Text('There are empty fields'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        )
                                      ],
                                    ));
                          } else {
                            createPostit(posicion, _controller[0],
                                    _controller[1], tags)
                                .then((salida) {
                              
                            
                              Navigator.of(context).pop(salida);
                            });
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  createPostit(coordenadas, titulo, descripcion, tags) async {
   
    DocumentReference ref = await db.collection("postit").add({
      'titulo': titulo.text,
      'descripcion': descripcion.text,
      'caducidad': DateTime.fromMicrosecondsSinceEpoch(
          DateTime.now().microsecondsSinceEpoch + 604800000000),
      'coordenadas': GeoPoint(coordenadas.latitude, coordenadas.longitude),
      'geohash': Geohash.encode(coordenadas.latitude, coordenadas.longitude)
          .substring(0, 7),
      'valoraciones': 0,
      'tags': tags,
      'ocult': ocult,
    });

    return ref.documentID;
  }
}

void printTag(List<String> tags) {
  TagRow(
    tags: tags,
  );
}
