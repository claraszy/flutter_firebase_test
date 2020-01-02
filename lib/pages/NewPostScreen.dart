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
  //TextEditingController _controller;
  List<TextEditingController> _controller;
  List<String> tags = [];
  String etiqueta;
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
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Container(
              child: Text('Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _controller[0],
              onSubmitted: (what) {
                //TODO
              },
              //keyboardType: TextInputType.number
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Container(child: Text('Description')),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _controller[1],
              onSubmitted: (what) {
                //TODO
              },
              //keyboardType: TextInputType.number
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0),
            child: Container(child: Text('Tags')),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _controller[2],
              onSubmitted: (what) {
                etiqueta = _controller[2].text.toString();
                setState(() {
                  tags.add(etiqueta);
                });
                printTag(tags);
                _controller[2].clear();
                //TODO
              },
              //keyboardType: TextInputType.number
            ),
          ),
          TagRow(tags: tags),
          /*Container(
                                child: Text(this.posicion.toString()),
                                 )*/
          Expanded(flex: 5, child: Container()),
          Expanded(
            flex: 2,
            child: Container(
              height: 50,
              color: Colors.grey,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: IconButton(
                      icon: Icon(Icons.publish),
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
      'title': titulo.text,
      'description': descripcion.text,
      'caducidad': DateTime.fromMicrosecondsSinceEpoch(
          DateTime.now().microsecondsSinceEpoch + 604800000000),
      'coordenadas': GeoPoint(coordenadas.latitude, coordenadas.longitude),
      //GeoPoint(41.564191, 2.017206),
      'geohash':Geohash.encode(coordenadas.latitude, coordenadas.longitude).substring(0, 7),
      'valoraciones': 0,
    });

    print('¡¡¡¡¡¡¡¡!!!!!!!!!!!!!!');
    print('¡¡¡¡¡¡¡¡!!!!!!!!!!!!!!');
    print('¡¡¡¡¡¡¡¡!!!!!!!!!!!!!!');
    print('¡¡¡¡¡¡¡¡!!!!!!!!!!!!!!');
    print('¡¡¡¡¡¡¡¡!!!!!!!!!!!!!!');
    print('¡¡¡¡¡¡¡¡!!!!!!!!!!!!!!');

    for (var i = 0; i < tags.length; i++) {
      print('Sube tags!!');
      await db
          .collection("postit")
          .document(ref.documentID)
          .collection("tags")
          .add({'tag': tags[i]});
    }
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
                        child: Text('# ' + widget.tags[index].toString())),
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
