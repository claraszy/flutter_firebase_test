import 'dart:async';

import 'package:firebase/model/postit.dart';
import 'package:firebase/pages/MapScreen.dart';
import 'package:firebase/pages/NewPostScreen.dart';
import 'package:firebase/pages/TrendingScreen.dart';
import 'package:firebase/subprogramas/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase/pages/root_page.dart';
import 'package:firebase/services/authentification.dart';

void main() => runApp(MyApp());


///COMENTARIO DE PRUEBA////
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(auth:  Auth()));
    
  }
}
