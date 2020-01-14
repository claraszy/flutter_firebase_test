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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'your posts',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
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
                SizedBox(height: 50),
                Expanded(
                    flex: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          //skip_previous
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 30.0,
                            color: Colors.grey[400],
                          ),
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
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 3,
                            color: Colors.grey[300],
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: 250,
                                  height: 40,
                                  color: Colors.grey,
                                  child: Center(
                                    child: Text(
                                      postit.titulo,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 250,
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Scrollbar(
                                        child: ListView(
                                          children: <Widget>[
                                            Text(
                                              postit.descripcion,
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                                Container(
                                  child: Chip(
                                    backgroundColor: Colors.white,
                                    deleteIconColor: Colors.black,
                                    deleteIcon: Text(postit.valoraciones.toString()),
                                    onDeleted: (){},
                                    label: Text(' Valoration: ',
                                      style: TextStyle(color: Colors.black, fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          //skip_previous
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 30.0,
                            color: Colors.grey[400],
                          ),
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
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          color: Colors.teal[200],
                          size: 20,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: Colors.teal[200], width: 2)),
                                color: Colors.white,
                                child: Text(
                                  'Back to profile',
                                  style: TextStyle(color: Colors.teal[200]),
                                ),
                                onPressed: () {
                                  //ProfileScreen
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProfileScreen(user_id),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
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
