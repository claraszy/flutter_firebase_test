import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewPostScreen extends StatefulWidget {
  LatLng posicion;
  NewPostScreen(this.posicion);

  @override
  _NewPostScreenState createState() => _NewPostScreenState(posicion);
}

class _NewPostScreenState extends State<NewPostScreen> {
  TextEditingController _controller;
  var posicion;
  _NewPostScreenState(this.posicion);
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post It'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _controller,
              onSubmitted: (what) {
                Navigator.of(context).pop(
                    what); // Se puede hacer tal y como Navigator.of(context).pop(_controller.text);
              },
              //keyboardType: TextInputType.number
            ),
          ),
          Container(
            child: Text(this.posicion.toString()),
          )
        ],
      ),
    );
  }
}
