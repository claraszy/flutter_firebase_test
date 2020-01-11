import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/postit.dart';
import 'package:firebase/pages/MapScreen.dart';
import 'package:firebase/pages/ProfileScreen.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrendingScreen extends StatefulWidget {
  TrendingScreen(this.userId);
  String userId;
  @override
  _TrendingScreenState createState() => _TrendingScreenState(this.userId);
}

class _TrendingScreenState extends State<TrendingScreen> {
  _TrendingScreenState(this.userIdk);
  int _selectedIndex = 1;
  String userIdk;
  String user_id = '';
  Future<LatLng> _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //print("${location.latitude}, ${location.longitude}");

    //print(_geohash.substring(0, 7));
    return LatLng(location.latitude, location.longitude);
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      print('user_id');
      print(this.user_id);
      _displayCurrentLocation().then((salida) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MapScreen(salida, this.user_id),
          ),
        );
        //print('Geohash');
        //print(Geohash.encode(my_geohash.latitude, my_geohash.longitude).substring(0, 7));
        //print('Hola');
      });
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileScreen(this.user_id),
        ),
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  final db = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.teal[900],
        title: Text(
          'trending now',
        ),
      ),
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
        ////////////el stream coge los 100 primeros postit con valoracion más alta, para asegurarnos de tener 10 tags distintos //////
        stream: db
            .collection('postit')
            .orderBy('valoraciones', descending: true)
            .limit(100)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LinearProgressIndicator(),
            );
          }

          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> docs = data.documents;
          List<Postit> listaDePostits = loadData(docs);
          List<String> trendingTags = [];
          for (var i = 0; i < listaDePostits.length; i++) {
            for (var a = 0; a < listaDePostits[i].tags.length; a++) {
              if (!trendingTags.contains(listaDePostits[i].tags[a])) {
                trendingTags.add(listaDePostits[i].tags[a]);
              }
              if (trendingTags.length >= 10) {
                break;
              }
            }
          }
          //print('userIdk');
          //print(user_id);
          if (userIdk != null && user_id == '') {
            user_id = userIdk;
          }
          return ListView.builder(
            itemCount: trendingTags.length,
            reverse: false,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Container(
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                title: Text(
                  trendingTags[index],
                  style: TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
