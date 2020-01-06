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
        ////////////el stream coge toda la colección de postit, sin ninguna condición, para tratarlos todos //////
        stream: db.collection('postit').orderBy('valoraciones').snapshots(),
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
                var postTags = docs[index].data['descripcion'];
                var postValoracion = docs[index].data['valoraciones'];
                String etiq = postTags[0];
                print(postTags);

                return ListTile(
                  leading: Container(
                    child: Text((docs.length - index).toString()),
                    width: 10,
                  ),
                  title: Text(postTags + '. VALORACIÓN ' + postValoracion.toString()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
