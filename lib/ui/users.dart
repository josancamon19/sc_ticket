import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sc_ticket/models/user.dart';
import 'package:sc_ticket/models/user_item_view.dart';
import 'package:sc_ticket/ui/create_ticket.dart';
import 'package:sc_ticket/ui/create_user.dart';

FirebaseDatabase firebaseDatabase;
DatabaseReference databaseReference;

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    super.initState();
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference().child("users");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: databaseReference != null
            ? Container(
                margin: EdgeInsets.only(top: 0.0),
                child: FirebaseAnimatedList(
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation animation, int index) {
                    User user = User.fromSnapshot(snapshot);
                    return UserView(
                      user: user,
                    );
                  },
                  query: databaseReference,
                ),
              )
            : Container(),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => CreateUser()));
            },
            icon: Icon(Icons.add),
            label: Text("New User")));
  }
}
