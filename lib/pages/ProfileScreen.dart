import 'package:firebase/pages/EditProfileScreen.dart';
import 'package:firebase/pages/MapScreen.dart';
import 'package:firebase/pages/TrendingScreen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MapScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrendingScreen(),
        ),
      );
    }
    setState(() {
      ///////// Cuando tengamos las otras dos páginas, establecemos aquí las rutas
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        title: Text(
          'ProfileScreen',
        ),
        backgroundColor: Colors.teal[900],
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_vert),
              tooltip: 'Editar perfil',
              highlightColor: Colors.pink[150],
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditProfileScreen(Objeto(
                          'Nuevo nombre',
                          'Nuevo username',
                          'new email',
                          '2020',
                          '2020',
                        ))));
              })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue,
            border: Border.all(
              width: 3,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(6.0))),
        child: Column(
          children: <Widget>[
            Text('NOMBRE'),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              width: 20,
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
