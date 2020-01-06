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
  EditProfileScreen(this.cosa);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //TextEditingController _controller;
  List<TextEditingController> _controller;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edita tu perfil:'),
          backgroundColor: Colors.teal[900],
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nombre'),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _controller[0],
                      onSubmitted: (what) {},
                    )),
                Text('Username'),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _controller[1],
                      onSubmitted: (what) {},
                    )),
                Text('E-mail'),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _controller[2],
                      onSubmitted: (what) {},
                    )),
                Text('Password'),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _controller[3],
                      onSubmitted: (what) {},
                    )),
                Text('Confirm Password'),
                Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: _controller[4],
                      onSubmitted: (what) {},
                    )),
                RaisedButton(
                  child: Text('Guardar'),
                  onPressed: () {
                    Navigator.of(context).pop(
                      Objeto(
                        _controller[0].text,
                        _controller[1].text,
                        _controller[2].text,
                        _controller[3].text,
                        _controller[4].text,
                      ),
                    );
                  },
                ),
              ],
            )));
  }
}
