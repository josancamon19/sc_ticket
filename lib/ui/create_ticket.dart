import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sc_ticket/models/ticket.dart';

FirebaseDatabase firebaseDatabase;
DatabaseReference databaseReference;

class CreateTicket extends StatefulWidget {
  final String userId;
  final String name;

  CreateTicket({this.userId, this.name});

  @override
  _CreateTicketState createState() => _CreateTicketState();
}

class _CreateTicketState extends State<CreateTicket> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  String _valueType = "Platform Issue";
  var types = [
    "Platform Issue",
    "Development or adjust",
    "New development",
    "Comercial area"
  ];

  @override
  void initState() {
    super.initState();
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference().child("tickets");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create new ticket')),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Are you having the problem with?',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 16.0,
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Tell us what is happening in detail',
                  border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 16.0,
            ),
            DropdownButton(
                value: _valueType,
                items: types.map((String type) {
                  return DropdownMenuItem(
                    child: Text(
                      type,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    value: type,
                  );
                }).toList(),
                onChanged: (String selected) {
                  _valueType = selected;
                  setState(() {});
                }),
            SizedBox(
              height: 16.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).buttonColor,
                    onPressed: uploadTicket,
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      'Submit ticket',
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

  void uploadTicket() {
    String title = _titleController.text;
    String description = _descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      return;
    }
    Query q = databaseReference.orderByValue().limitToLast(1);
    q.once().then((DataSnapshot snapshot) {
      String id = getLastTicketId(snapshot);
      String newId = "0";
      if (id != null) {
        newId = (int.parse(id) + 1).toString();
      }
      insertTicket(newId, title, description);
    });
  }

  String getLastTicketId(DataSnapshot snapshot) {
    String snapStr = snapshot.value.toString();
    int initialIndex = snapStr.indexOf('id');
    int lastIndex = snapStr.indexOf('}');
    String id;
    try {
      print(snapStr.substring(initialIndex));
      id = snapStr.substring(initialIndex + 4, lastIndex);
      print(id);
    } catch (e) {
      print(e);
      id = null;
    }
    return id;
  }

  void insertTicket(String id, String title, String description) {
    var now = DateTime.now().toIso8601String();
    String date = now.split('T')[0];
    String time = now.split('T')[1].split('.')[0];
    Ticket newTicket = Ticket(
        id: id,
        userId: widget.userId,
        username: widget.name,
        title: title,
        description: description,
        type: _valueType,
        state: 'Open',
        date: date,
        time: time);
    databaseReference.child(id).set(newTicket.toJson()).then((s) {
      insertTicketInUser(newTicket);
    });
  }

  void insertTicketInUser(Ticket ticket) {
    DatabaseReference ticketsReference = firebaseDatabase
        .reference()
        .child("users")
        .child(widget.userId)
        .child("tickets");
    ticketsReference
        .orderByValue()
        .limitToLast(1)
        .once()
        .then((DataSnapshot snapshot) {
      print(snapshot.value);
      String id = getLastTicketId(snapshot);
      String newIdKey;
      if (id == null) {
        newIdKey = "0";
      } else {
        newIdKey = (int.parse(id) + 1).toString();
      }
      ticketsReference.child(newIdKey).set(ticket.toJson()).then((s) {
        Navigator.pop(context);
      });
    });
  }
}
