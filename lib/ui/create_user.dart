import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sc_ticket/models/user.dart';

class CreateUser extends StatefulWidget {
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Name'),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Username'),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).buttonColor,
                    onPressed: saveUser,
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Create User',
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void saveUser() {
    String name = _nameController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;

    User user =
        new User(id: null, name: name, username: username, password: password);
    DatabaseReference _ref =
        FirebaseDatabase.instance.reference().child('users');

    Query q = _ref.orderByChild('id').limitToLast(1);

    q.once().then((DataSnapshot snapshot) {
      String lastId = getUserId(snapshot);
      String id = (int.parse(lastId) + 1).toString();
      print('the new id is: $id');
      user.id = id;
      _ref.child(user.id).set(user.toJson()).whenComplete((){
        Navigator.pop(context);
      });
    });
  }

  String getUserId(DataSnapshot snapshot) {
    String snapStr = snapshot.value.toString();
    int initialIndex = snapStr.lastIndexOf('id');
    String substringFromId = snapStr.substring(initialIndex + 4);
    String id;
    try {
      print(snapStr.substring(initialIndex));
      id = substringFromId.substring(0, substringFromId.lastIndexOf(','));
      print('id in first try: $id');
    } catch (e) {
      try {
        id = substringFromId.substring(0, substringFromId.lastIndexOf('}'));
        id = id.replaceAll('}', '');
        print('id in sechond try: $id');
      } catch (e) {
        id = null;
      }
    }
    return id;
  }
}
