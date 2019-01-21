import 'package:flutter/material.dart';
import 'package:sc_ticket/ui/home.dart';
import 'package:sc_ticket/ui/login.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
    title: 'S&C Tickets',
    debugShowCheckedModeBanner: false,
  ));
}
