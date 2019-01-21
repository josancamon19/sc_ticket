import 'package:firebase_database/firebase_database.dart';

class User {
  String id;
  final String name;
  final String username;
  final String password;

  User({this.id, this.name, this.username, this.password});

  User.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value['id'],
        name = snapshot.value['name'],
        username = snapshot.value['username'],
        password = snapshot.value['password'];

  User.fromMap(Map map)
      : id = map['id'],
        name = map['name'],
        username = map['username'],
        password = map['password'];

  toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'password': password,
    };
  }
}
