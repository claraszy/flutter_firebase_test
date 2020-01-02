import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

Widget drawer() {
  //TODO
  //Pasar por parametro los TAGS que hayan en este Geohash
  List<String> lista = ['Enano', 'Android', 'Fiesta'];
  return Drawer(
    elevation: 16.0,
    child: ListView.builder(
      itemCount: lista.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () {},
        child: ListTile(
          title: Text("#" + lista[index]),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    ),
  );
}
