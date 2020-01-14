import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/postit.dart';
import 'package:firebase/pages/MapScreen.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mydrawer extends StatefulWidget {
  Mydrawer(this._filtered, this.my_geohash);
  List<String> _filtered;
  String my_geohash;
  @override
  _MydrawerState createState() =>
      _MydrawerState(this._filtered, this.my_geohash);
}

class _MydrawerState extends State<Mydrawer> {
  _MydrawerState(this._filtered, this.my_geohash);
  String my_geohash;
  List<String> _filtered;
  final db = Firestore.instance;
  // cargar informacion del geohash en el que estes

  Future<LatLng> _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return LatLng(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
          stream: db
              .collection('postit')
              .where('geohash', isEqualTo: this.my_geohash)
              .limit(100)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            QuerySnapshot data = snapshot.data;
            List<DocumentSnapshot> docs = data.documents;
            List<Postit> lista = loadData(docs);
            List<String> drawerTags = [];

            for (var i = 0; i < lista.length; i++) {
              for (var a = 0; a < lista[i].tags.length; a++) {
                if (!drawerTags.contains(lista[i].tags[a])) {
                  drawerTags.add(lista[i].tags[a]);
                }
              }
            }
            return ListView.builder(
              itemCount: drawerTags.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  setState(() {
                    if (_filtered.contains(drawerTags[index])) {
                      _filtered.remove(drawerTags[index]);
                    } else {
                      _filtered.add(drawerTags[index]);
                    }
                  });
                  // mostrar solo los marcadores con el tag clicado
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Text("#" + drawerTags[index]),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            );
          }),
    );
  }
}
