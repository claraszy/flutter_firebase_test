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
        stream: db
            .collection('postit')
            .orderBy('valoraciones', descending: true)
            .limit(10)
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

          return ListView.builder(
            itemCount: docs.length,
            reverse: false,
            itemBuilder: (context, index) {
              var post = data.documents[index];
              var postitTag = post.data;
              var tagdePost = snapshot.data.documents[index].data['tags'];
              List<String> listaTagsPost = post.data['tags'];
              var valoracionPost = post.data['valoraciones'];
              var descripcionPost = post.data['descripcion'];

              /// var postTags = docs[index].data['descripcion'];
              ///var postValoracion = docs[index].data['valoraciones'];
              return ListTile(
                  leading: Container(
                    child: Text((index + 1).toString()),
                  ),
                  title: Text(descripcionPost +
                      '. VALORACIÓN DE ' +
                      valoracionPost.toString()));
            },
          );
        },
      ),
    );
  }
}
