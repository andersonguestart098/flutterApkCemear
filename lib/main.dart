import 'package:cemear/views/assinatura.dart';
import 'package:cemear/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue
    ),
    routes: {
      "/":(context) => Home(),
      "/assinatura":(context) => Assinatura()

    },
  ));
}
