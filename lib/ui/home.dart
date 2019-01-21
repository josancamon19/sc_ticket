import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:sc_ticket/models/ticket.dart';
import 'package:sc_ticket/models/ticket_item_view.dart';
import 'package:sc_ticket/ui/create_ticket.dart';
import 'package:sc_ticket/ui/create_user.dart';
import 'package:sc_ticket/ui/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseDatabase firebaseDatabase;
DatabaseReference databaseReference;

String id;
String name;
String username;
String password;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    firebaseDatabase = FirebaseDatabase.instance;
    getUserData();
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("id");
    name = prefs.getString("name");
    username = prefs.getString("username");
    print(username);
    password = prefs.getString("password");
    print('user id is $id');
    if (username == "wilmarux") {
      databaseReference = firebaseDatabase.reference().child("tickets");
    } else {
      print('no wilmarux');
      databaseReference = firebaseDatabase
          .reference()
          .child("users")
          .child(id)
          .child("tickets");
    }
    setState(() {});
  }

  Future<bool> _onWillPop() {
    return showDialogLogout() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("S&C Tickets"),
          elevation: 6.0,
          leading: Container(),
          actions: <Widget>[
            username == "wilmarux"
                ? IconButton(
                    icon: Icon(Icons.person_add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Users()));
                    },
                  )
                : Container(),
          ],
        ),
        floatingActionButton: username != "wilmarux"
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CreateTicket(userId:id,name: name ,)));
                },
                icon: Icon(Icons.add),
                label: Text("New Ticket"))
            : Container(),
        body: databaseReference != null
            ? Container(
                margin: EdgeInsets.only(top: 0.0),
                child: FirebaseAnimatedList(
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation animation, int index) {
                    Ticket ticket = Ticket.fromSnapshot(snapshot);
                    return TicketView(
                      ticket: ticket,
                    );
                  },
                  query: databaseReference,
                ),
              )
            : Container(),
      ),
    );
  }

  Future<bool> showDialogLogout() {
    var alert = AlertDialog(
      title: Text('Wait'),
      content: Text('are you sure you want to sign out?'),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
            child: Text('YES'),
            onPressed: () {
              removeSharedPreferences();
              Navigator.pop(context);
              Navigator.pop(context);
              //exit(0);
            }),
      ],
    );
    return showDialog(
        context: context, builder: (BuildContext context) => alert);
  }

  removeSharedPreferences() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('id');
    sp.remove('name');
    sp.remove('username');
    sp.remove('password');
  }

  @override
  void dispose() {
    firebaseDatabase = null;
    databaseReference = null;
    id = null;
    name = null;
    username = null;
    password = null;
    super.dispose();
  }
}
