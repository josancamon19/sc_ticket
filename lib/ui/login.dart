import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sc_ticket/models/user.dart';
import 'package:sc_ticket/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseDatabase _firebaseDatabase;
DatabaseReference _usersReference;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseDatabase = FirebaseDatabase.instance;
    _usersReference = _firebaseDatabase.reference().child("users");
    checkPreviousLogin();
  }

  void checkPreviousLogin() async {
    await SharedPreferences.getInstance().then((SharedPreferences sp) {
      String username;
      try{
        username = sp.getString("username");
      }catch(e){

      }
      if (username != null) {
        Query q = _usersReference.orderByChild("username").equalTo(username);
        q.once().then((DataSnapshot snapshot) {
          String id = getUserId(snapshot);
          _usersReference.child(id).once().then((DataSnapshot snapshot) {
            print(snapshot.value);
            User user = User.fromSnapshot(snapshot);
            saveLoginData(username, password, user.id, user.name);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          });
        });
      } else {
        print('user not signin yet');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: _passwordController,
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
                      onPressed: searchUsername,
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white, fontSize: 24.0),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void searchUsername() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      showAlertLoginWrong('Both fields required');
      return;
    }
    print(username);
    Query q = _usersReference.orderByChild("username").equalTo(username).limitToFirst(1);
    q.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      String id = getUserId(snapshot);
      _usersReference.child(id).once().then((DataSnapshot snapshot) {
        print(snapshot.value);
        User user = User.fromSnapshot(snapshot);
        if (user.password == password) {
          saveLoginData(username, password, user.id, user.name);
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => Home()));
        } else {
          showAlertLoginWrong('Password is wrong');
        }
      });
    }).catchError((e) {
      print('error is');
      print(e);
      showAlertLoginWrong('The username does not exist');
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
        id =id.replaceAll('}', '');
        print('id in sechond try: $id');
      } catch (e) {
        id = null;
      }
    }
    return id;
  }

  void saveLoginData(
      String username, String password, String id, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('name', name);
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  void showAlertLoginWrong(String content) {
    var alert = AlertDialog(
      title: Text('Try again'),
      content: Text(content),
      actions: <Widget>[
        FlatButton(onPressed: () => Navigator.pop(context), child: Text('Ok'))
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
