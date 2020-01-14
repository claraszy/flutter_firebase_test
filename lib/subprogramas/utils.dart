import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/postit.dart';
import 'package:firebase/model/usuarios.dart';

List<Postit> loadData(List<DocumentSnapshot> docs) {
  //print(docs);
  List<Postit> post = [];
  for (var i = 0; i < docs.length; i++) {
    List<String> tags = List<String>.from(docs[i].data['tags']);
    // print(docs[i].documentID);
    //for (var pos = 0; i < docs[i].data['tags'].length; pos++) {}
    post.add(
      Postit(
          docs[i].data['titulo'],
          docs[i].data['coordenadas'],
          docs[i].data['descripcion'],
          docs[i].data['valoraciones'],
          docs[i].data['caducidad'],
          docs[i].data['geohash'],
          tags,
          docs[i].data['ocult'],
          docs[i].documentID),
    );
  }
  return post;
}

Perfil loadDataUser(users) {
  //print(docs);
  print(users['nValoraciones']);
  List auxiliares_pgustados = [];
  List auxiliares_pVigentes = [];
  if (users['pGustados'] != null) {
    auxiliares_pgustados = users['pGustados'];
  }
  if (users['pVigentes'] != null) {
    auxiliares_pVigentes = users['pVigentes'];
  }
  Perfil perfil = Perfil(
    users['alias'],
    users['email'],
    users['foto'],
    users['nombre'],
    users['nPublicaciones'],
    users['nValoraciones'],
    auxiliares_pgustados,
    auxiliares_pVigentes,
  );

  return perfil;
}
