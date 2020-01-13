import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/postit.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/material.dart';

import 'ProfileScreen.dart';

class ListPostitsScreen extends StatefulWidget {
  ListPostitsScreen(this.pVigentes, this.user_id, this.indice);
  List<dynamic> pVigentes;
  String user_id;
  int indice;
  @override
  _ListPostitsScreenState createState() =>
      _ListPostitsScreenState(this.pVigentes, this.user_id, this.indice);
}

class _ListPostitsScreenState extends State<ListPostitsScreen> {
  _ListPostitsScreenState(this.pVigentes, this.user_id, this.indice);
  List<dynamic> pVigentes;
  String user_id;
  int indice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Tus post',
          style: TextStyle(color: Colors.teal),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('postit')
              .document(pVigentes[indice])
              .snapshots(),
          //todooo reemplazar  Pthm29uGoWu9mpwGhqZK por userid
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapd) {
            if (!snapd.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            //snapd.data.data['alias']
            Postit postit = Postit(
                snapd.data.data['titulo'],
                snapd.data.data['posicion'],
                snapd.data.data['descripcion'],
                snapd.data.data['valoraciones'],
                snapd.data.data['caducidad'],
                snapd.data.data['geohash'],
                snapd.data.data['tags'],
                snapd.data.data['oculto'],
                snapd.data.data['referencias']);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          //skip_previous
                          icon: Icon(Icons.skip_previous, size: 36.0),
                          onPressed: () {
                            if (indice > 0) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ListPostitsScreen(
                                      pVigentes, user_id, indice - 1),
                                ),
                              );
                            }
                          },
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(postit.titulo),
                              ),
                              Container(
                                  width: 270,
                                  child: Text(
                                    postit.descripcion,
                                    textAlign: TextAlign.center,
                                  )),
                              Container(
                                  child: Text(postit.valoraciones.toString())),
                            ],
                          ),
                        ),
                        IconButton(
                          //skip_previous
                          icon: Icon(Icons.skip_next, size: 36.0),
                          onPressed: () {
                            if (pVigentes.length - 1 > indice) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ListPostitsScreen(
                                      pVigentes, user_id, indice + 1),
                                ),
                              );
                            }
                          },
                        )
                      ],
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Text('Perfil'),
                          onPressed: () {
                            //ProfileScreen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(user_id),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
