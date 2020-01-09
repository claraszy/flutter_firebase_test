import 'package:firebase/pages/EditProfileScreen.dart';
import 'package:firebase/pages/MapScreen.dart';
import 'package:firebase/pages/TrendingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

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

  final BigDivider = Container(
    height: 30,
    color: Colors.transparent,
  );
  final Divider = Container(
    height: 10,
    color: Colors.transparent,
  );

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
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Container(color: Colors.white, child: Lista_postits()),
          GranContainer(BigDivider: BigDivider, Divider: Divider),
          FotoPerfil(),
        ],
      ),
    );
  }
}

class GranContainer extends StatelessWidget {
  const GranContainer({
    Key key,
    @required this.BigDivider,
    @required this.Divider,
  }) : super(key: key);

  final Container BigDivider;
  final Container Divider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.teal,
        ),
        height: 225,
        child: Column(
          children: <Widget>[
            BigDivider,
            Text(
              'name',
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
            Divider,
            Text('@nickname',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
            BigDivider,
            BigDivider,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey[100],
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
                          Text('  Post: '),
                          Container(
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Text(
                              '${vectorPostits.length}',
                            ),
                          ),
                          Expanded(child: Container()),
                          Text('Likes:  '),
                          Container(
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                            ),
                            child: Text('${ContLikeTotals().toString()}'),
                          )
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
        padding: const EdgeInsets.only(top: 100.0),
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
                child: Card(
                  child: ListTile(
                    title: Text(
                      vectorPostits[index].title,
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Text(vectorPostits[index].descripcion),
                        Expanded(child: Container()),
                        Icon(
                          Icons.thumb_up,
                          color: Colors.green,
                        ),
                        Text(vectorPostits[index].likes.toString()),
                        prefix0.Container(width: 3),
                        Icon(Icons.thumb_down, color: Colors.red),
                        prefix0.Container(width: 1),
                        Text(vectorPostits[index].dislikes.toString()),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
