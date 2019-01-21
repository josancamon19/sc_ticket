import 'package:firebase_database/firebase_database.dart';

class Ticket {
  final String id;
  final String userId;
  final String username;
  final String title;
  final String type;
  final String description;
  String state;
  final String date;
  final String time;

  Ticket(
      {this.id,
      this.userId,
      this.username,
      this.title,
      this.type,
      this.description,
      this.state,
      this.date,
      this.time});

  Ticket.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value['id'],
        userId = snapshot.value['userId'],
        username = snapshot.value['userName'],
        title = snapshot.value['title'],
        type = snapshot.value['type'],
        description = snapshot.value['description'],
        state = snapshot.value['state'],
        date = snapshot.value['date'],
        time = snapshot.value['time'];

  Ticket.fromMap(Map map)
      : id = map['id'],
        userId = map['userId'],
        username = map['userName'],
        title = map['title'],
        type = map['type'],
        description = map['description'],
        state = map['state'],
        date = map['date'],
        time = map['time'];

  toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': username,
      'title': title,
      'type': type,
      'description': description,
      'state': state,
      'date': date,
      'time': time,
    };
  }
}
