import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/postit.dart';
import 'package:firebase/model/usuarios.dart';

List<Postit> loadData(List<DocumentSnapshot> docs) {
  //print(docs);
  List<Postit> post = [];
  for (var i = 0; i < docs.length; i++) {
    List<String> tags = List<String>.from(docs[i].data['tags']);

    //for (var pos = 0; i < docs[i].data['tags'].length; pos++) {}
    post.add(Postit(
        docs[i].data['titulo'],
        docs[i].data['coordenadas'],
        docs[i].data['descripcion'],
        docs[i].data['valoraciones'],
        docs[i].data['caducidad'],
        docs[i].data['geohash'],
        tags,
        docs[i].data['ocult']));
  }
  return post;
}

List<Perfil> loadDataUser(List<DocumentSnapshot> users) {
  //print(docs);
  List<Perfil> perfil = [];
  for (var i = 0; i < users.length; i++) {
    perfil.add(Perfil(
      users[i].data['alias'],
      users[i].data['email'],
      users[i].data['foto'],
      users[i].data['nombre'],
      users[i].data['nPublicaciones'],
      users[i].data['nValoraciones'],
      users[i].data['pGustados'],
      users[i].data['pVigentes'],
    ));
  }
  return perfil;
}
