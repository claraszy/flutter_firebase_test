import 'package:flutter/material.dart';

class ListPostitsScreen extends StatefulWidget {
  @override
  _ListPostitsScreenState createState() => _ListPostitsScreenState();
}

class _ListPostitsScreenState extends State<ListPostitsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Tus post',
          style: TextStyle(color: Colors.teal),
        ),
        backgroundColor: Colors.white,
    
        actions: <Widget>[
         
        ],
      ),
    );
  }
}