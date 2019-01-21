import 'package:flutter/material.dart';
import 'package:sc_ticket/models/user.dart';

class UserView extends StatefulWidget {
  final User user;

  const UserView({Key key, this.user}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0.0,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          child: ListTile(
            title: Text(
              widget.user.name,
              style: TextStyle(fontSize: 20.0),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.user.username,
                    style: TextStyle(fontSize: 16.0),),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.user.password,
                    style: TextStyle(fontSize: 16.0),),
                ),
              ],
            ),
            leading: CircleAvatar(
              child: Text(widget.user.name[0]),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tickets',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Edit',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
