//import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool ocult = true;
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
  
 // bool estatOcult = ocult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.greenAccent[100],
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
                  Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        child: Text(
                          "new post it",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: FlatButton(
                          child: Icon(
                            Icons.thumbs_up_down,
                            color: (ocult ? Colors.grey[400] : Colors.teal),
                          ),
                          onPressed: (){},
                          onLongPress: () {
                            setState(() {
                              ocult = !ocult;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: Text(
                      'Title',
                      style: TextStyle(fontSize: 15),
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
                      fillColor: Colors.white,
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
                      style: TextStyle(fontSize: 15),
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
                        fillColor: Colors.white,
                      ),
                      controller: _controller[1],
                      onSubmitted: (what) {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 8),
                    child: Text(
                      '#tags',
                      style: TextStyle(fontSize: 15),
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
                      fillColor: Colors.white,
                    ),
                    controller: _controller[2],
                    onSubmitted: (what) {
                      etiqueta = _controller[2].text.toString();
                      setState(() {
                        tags.add(etiqueta);
                      });
                      printTag(tags);
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
              color: Colors.teal[400],
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 50),
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.grey[700],
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        left: 19.0,
                        right: 19.0,
                      ),
                      child: Container(
                        width: 1,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 60.0, left: 55),
                    child: IconButton(
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: Colors.purple,
                        size: 35,
                      ),
                      onPressed: () {
                        createPostit(
                                posicion, _controller[0], _controller[1], tags)
                            .then((salida) {
                          //TODO
                          //Devolver la referencia y añadir al usuario que ha hecho el upload
                          print(salida);
                          Navigator.of(context).pop(salida);
                        });
                      },
                    ),
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
    /*await db.collection("postit").document("1").setData({
                        'title': 'Mastering Flutter',
                        'description': 'Programming Guide for Dart'
                      });*/
    print(coordenadas);
    print(titulo.text);
    print(descripcion.text);
    //print(tags.text);
    DocumentReference ref = await db.collection("postit").add({
      'titulo': titulo.text,
      'descripcion': descripcion.text,
      'caducidad': DateTime.fromMicrosecondsSinceEpoch(
          DateTime.now().microsecondsSinceEpoch + 604800000000),
      'coordenadas': GeoPoint(coordenadas.latitude, coordenadas.longitude),
      //GeoPoint(41.564191, 2.017206),
      'geohash': Geohash.encode(coordenadas.latitude, coordenadas.longitude)
          .substring(0, 7),
      'valoraciones': 0,
      'tags': tags,
    });

    return ref.documentID;
  }
}

void printTag(List<String> tags) {
  TagRow(
    tags: tags,
  );
}

class TagRow extends StatefulWidget {
  const TagRow({
    Key key,
    @required this.tags,
  }) : super(key: key);

  final List<String> tags;

  @override
  _TagRowState createState() => _TagRowState();
}

class _TagRowState extends State<TagRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300,
      height: 50,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.tags.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: Colors.grey[400],
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
                          '# ' + widget.tags[index].toString(),
                          overflow: TextOverflow.clip,
                        )),
                    onLongPress: () {
                      setState(() {
                        widget.tags.remove(widget.tags[index]);
                      });
                    },
                    //title: Text('#${tags[index]}', style: TextStyle(fontSize: 12),),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
