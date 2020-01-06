import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/postit.dart';
import 'package:firebase/pages/MapScreen.dart';
import 'package:firebase/pages/ProfileScreen.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/material.dart';

class TrendingScreen extends StatefulWidget {
  @override
  _TrendingScreenState createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
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
        ////////////la condición isGreatherThan no sirve, tiene que ser que son las 10 puntuaciones más altas //////
        stream: db
            .collection('postit')
            .where('valoraciones', isGreaterThan: 100)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LinearProgressIndicator(),
            );
          }
          QuerySnapshot data = snapshot.data;
          List<DocumentSnapshot> docs = data.documents;

          /// List<Postit> lista= loadData(docs);

          return Scrollbar(
            child: ListView.builder(
              itemCount: docs.length,
              reverse: true,
              itemBuilder: (context, index) {
                var postvaloration =
                    docs[index].data['valoraciones'].toString();
                for (var pos = 2; pos < docs.length; pos++) {
                  return ListTile(
                    leading: Container(child: Text(pos.toString()), width: 10,),
                    ///////////////// contenido del ListTile /////////////
                    title: Text(postvaloration),
                    
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
