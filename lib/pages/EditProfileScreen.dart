import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/////////////////////////////////////////////////////////////////////////////

class Objeto {
  String name, username, email, password, confirmPassword;

  Objeto(this.name, this.username, this.email, this.password,
      this.confirmPassword);
}

/////////////////////////////////////////////////////////////////////////////

class EditProfileScreen extends StatefulWidget {
  final Objeto cosa;
  EditProfileScreen(this.userId, this.cosa);
  String userId;
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState(this.userId);
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  _EditProfileScreenState(this.userId);
  //TextEditingController _controller;
  List<TextEditingController> _controller;
  String userId;
  void initState() {
    //_controller = TextEditingController();
    //_controller = [for (int i = 0; i < 3; i++) TextEditingController(),];
    // Tambien puedes iniciarlo lleno ---> _controller = TextEditingController(text: widget.enter.toString(),);
    _controller = [
      TextEditingController(
        text: widget.cosa.name.toString(),
      ),
      TextEditingController(
        text: widget.cosa.username.toString(),
      ),
      TextEditingController(
        text: widget.cosa.email.toString(),
      ),
      TextEditingController(
        text: widget.cosa.password.toString(),
      ),
      TextEditingController(
        text: widget.cosa.confirmPassword.toString(),
      ),
    ];
    super.initState();
  }

  void applyChanges(referencias, controler) {
    print(controler[0].text);
    Firestore.instance.collection('usuarios').document(referencias).updateData({
      "nombre": controler[0].text,
      "alias": controler[1].text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text('Profile editing', style: TextStyle(fontSize: 18, color: Colors.teal),),
        backgroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name'),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  style: TextStyle(color: Colors.grey[600]),
                  controller: _controller[0],
                  onSubmitted: (what) {},
                )),
            Text('Username'),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                                    style: TextStyle(color: Colors.grey[600]),

                  controller: _controller[1],
                  onSubmitted: (what) {},
                )),
            Text('E-mail'),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                                    style: TextStyle(color: Colors.grey[600]),

                  controller: _controller[2],
                  onSubmitted: (what) {},
                )),
            Text('Password'),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  obscureText: true,
                  controller: _controller[3],
                                    style: TextStyle(color: Colors.grey[600]),

                  onSubmitted: (what) {},
                )),
            Text('Confirm Password'),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextField(
                  obscureText: true,
                  controller: _controller[4],
                                    style: TextStyle(color: Colors.grey[600]),

                  onSubmitted: (what) {},
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  hoverColor: Colors.teal,
                  child: Text('Save', style: TextStyle(color: Colors.grey[700]),),
                  onPressed: () {
                    applyChanges(userId, _controller);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
