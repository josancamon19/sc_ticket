import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sc_ticket/models/ticket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketDetails extends StatefulWidget {
  Ticket ticket;
  TicketDetails({Key key, this.ticket}) : super(key: key);

  @override
  _TicketDetailsState createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  FirebaseDatabase firebaseDatabase;
  DatabaseReference _refTickets;
  DatabaseReference _refUserTickets;
  List<String> states = ['Open', 'In progress', 'Closed', 'Re-open'];

  String username;
  @override
  void initState() {
    super.initState();
    getUserData();
    firebaseDatabase = FirebaseDatabase.instance;
    _refTickets = firebaseDatabase.reference().child('tickets');
    _refUserTickets = firebaseDatabase
        .reference()
        .child('users')
        .child(widget.ticket.userId)
        .child('tickets');
  }
  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    Ticket ticket = widget.ticket;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text(
              ticket.title,
              style: TextStyle(fontSize: 20.0),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ticket.type,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black87, fontSize: 16.0),
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Time: ${ticket.time.substring(0, 5)}\nDate: ${ticket.date}',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ticket.description,
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${ticket.username}',
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
            username == "wilmarux"?
            Align(
              alignment: Alignment.centerLeft,
              child: DropdownButton(
                  value: ticket.state,
                  items: states.map((String item) {
                    return DropdownMenuItem(
                      child: Text(item),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (String state) {
                    ticket.state = state;
                    setState(() {});
                  }),
            ):Container(),
            username == "wilmarux"?
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    elevation: 6.0,
                    highlightElevation: 12.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    color: Theme.of(context).primaryColor,
                    onPressed: updateTicket,
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Update State',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ):Container(),
            SizedBox(height:16.0),
            username != "wilmarux"?
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Ticket State:  ${ticket.state}',style: TextStyle(fontSize: 20.0),),
            ):Container()
          ],
        ),
      ),
    );
  }

  void updateTicket() {
    Query q = _refUserTickets.orderByChild("id").equalTo(widget.ticket.id);
    q.once().then((DataSnapshot snapshot) {
      print(snapshot.value);
      String id = getUserTicketId(snapshot);
      _refUserTickets.child(id).set(widget.ticket.toJson()).then((s) {
        _refTickets
            .child(widget.ticket.id)
            .set(widget.ticket.toJson())
            .then((a) {
          Navigator.pop(context);
        });
      });
    });
    //
  }

  String getUserTicketId(DataSnapshot snapshot) {
    String snapStr = snapshot.value.toString();
    int initialIndex = snapStr.lastIndexOf('id');
    String substringFromId = snapStr.substring(initialIndex + 4);
    String id;
    try {
      print(snapStr.substring(initialIndex));
      id = substringFromId.substring(0, substringFromId.lastIndexOf(','));
      print('id in first try: $id');
      if (id.length > 5) {
        id = substringFromId.substring(0, substringFromId.indexOf(','));
        id = id.replaceAll('}', '');
        print('id in first try and if: $id');
      }
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
