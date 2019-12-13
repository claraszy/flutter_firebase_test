import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/postit.dart';

List<Postit> loadData(List<DocumentSnapshot> docs) {
  List<Postit> post = [];
  for (var i = 0; i < docs.length; i++) {
    post.add(Postit(docs[i].data['coordenadas'], docs[i].data['descripcion'],
        docs[i].data['valoraciones'], docs[i].data['caducidad']));
  }
  return post;
}
