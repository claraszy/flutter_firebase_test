import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/usuarios.dart';
import 'package:firebase/pages/EditProfileScreen.dart';
import 'package:firebase/pages/MapScreen.dart';
import 'package:firebase/pages/TrendingScreen.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// HAY QUE PONERLE COLOR DE FONDO AL LIST VIEW (COLORS.GREY[300]) PARA QUE QUEDE UNIFORME

////////////////////////////////////////////////////////////////////////////////
class _PostitProfile {
  String title, descripcion, location;
  int likes, dislikes;
  _PostitProfile(
      this.title, this.descripcion, this.location, this.likes, this.dislikes);
}

final vectorPostits = [
  _PostitProfile('boy enano', 'gran club', 'terrassa', 300, 2),
  _PostitProfile(
      'zhomas mateo', 'chico parecido a Jim Carrey', 'terrassa', 1, 1),
  _PostitProfile('title', 'descripcion', 'location', 345, 345),
  _PostitProfile('title', 'descripcion', 'location', 3, 8),
  _PostitProfile('title', 'descripcion', 'location', 3, 8),
  _PostitProfile('title', 'descripcion', 'location', 3, 8),
  _PostitProfile('title', 'descripcion', 'location', 3, 8),
  _PostitProfile('title', 'descripcion', 'location', 3, 8)
];

int ContLikeTotals() {
  int LikesTotals = 0;
  int i;

  for (i = 0; i < vectorPostits.length; i++) {
    LikesTotals = LikesTotals + vectorPostits[i].likes;
  }
  return LikesTotals;
}

///////////////////////////////////////////////////////////////////////////

class ProfileScreen extends StatefulWidget {
  ProfileScreen(this.userId);
  String userId;
  @override
  _ProfileScreenState createState() => _ProfileScreenState(this.userId);
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileScreenState(this.userId);
  int _selectedIndex = 2;
  String userId;

  Future<LatLng> _displayCurrentLocation() async {
    final location = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //print("${location.latitude}, ${location.longitude}");

    //print(_geohash.substring(0, 7));
    return LatLng(location.latitude, location.longitude);
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      _displayCurrentLocation().then((salida) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MapScreen(salida, userId),
          ),
        );
        //print('Geohash');
        // print(Geohash.encode(my_geohash.latitude, my_geohash.longitude).substring(0, 7));
        //print('Hola');
      });
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TrendingScreen(userId),
        ),
      );
    }
    setState(() {
      ///////// Cuando tengamos las otras dos páginas, establecemos aquí las rutas
      _selectedIndex = index;
    });
  }

  final BigDivider = Container(
    height: 30,
    color: Colors.transparent,
  );
  final Divider = Container(
    height: 10,
    color: Colors.transparent,
  );

  final userdata = Firestore.instance;
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
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Tu Perfil',
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              tooltip: 'Editar perfil',
              color: Colors.teal,
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
      body: StreamBuilder(
        stream: userdata
            .collection('usuarios')
            .document("Pthm29uGoWu9mpwGhqZK")
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapd) {
          if (!snapd.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // print('userIdProfile');
          //print(this.userId);

          //print(snapd.data.data);
          print(snapd.data.data['alias']);

          //List<DocumentSnapshot> alias = snapd.data.data['alias'];

          Perfil listaDelUsuario = loadDataUser(snapd.data.data);

          List<String> vectorUsuario = [];

          print(listaDelUsuario.pVigentes);

          return Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Container(color: Colors.white, child: Lista_postits()),
              GranContainer(listaDelUsuario,BigDivider: BigDivider, Divider: Divider),
              FotoPerfil(),
            ],
          );
        },
      ),
    );
  }
}

class GranContainer extends StatelessWidget {
  const GranContainer(
    this.perfil, {
    Key key,
    @required this.BigDivider,
    @required this.Divider,
  }) : super(key: key);
    final Perfil perfil;
  final Container BigDivider;
  final Container Divider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        height: 225,
        child: Column(
          children: <Widget>[
           
             Text( perfil.nombre,style: TextStyle(  fontSize: 25,color: Colors.black, fontWeight: FontWeight.w900,), ),
            Divider,
            Text('@ ' + perfil.alias,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            BigDivider,
            BigDivider,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0))),
                width: 400,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Chip(
                            backgroundColor: Colors.white,
                            label: Text(
                              'Posts: '+ perfil.pVigentes.length.toString(),
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Expanded(child: Container()),
                          Chip(
                            backgroundColor: Colors.white,
                            label: Text(
                              'Likes: ${ContLikeTotals().toString()} ',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                          /*Text('Likes:  '),
                          Container(
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Text('${ContLikeTotals().toString()}'),
                          )
                          */
                        ],
                      ),
                      Divider,
                      Text(
                        'what you posted',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FotoPerfil extends StatelessWidget {
  const FotoPerfil({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class Cards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Lista_postits(),
    );
  }
}

class Lista_postits extends StatelessWidget {
  const Lista_postits({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 215),
        itemCount: vectorPostits.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            child: Card(
              elevation: 0.7,
              child: ListTile(
                title: Text(
                  vectorPostits[index].title,
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text(
                      vectorPostits[index].descripcion,
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        Icons.thumb_up,
                        color: Colors.green[800],
                        size: 15,
                      ),
                    ),
                    Text(vectorPostits[index].likes.toString()),
                    prefix0.Container(width: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(
                        Icons.thumb_down,
                        color: Colors.red[800],
                        size: 15,
                      ),
                    ),
                    prefix0.Container(width: 1),
                    Text(vectorPostits[index].dislikes.toString()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
