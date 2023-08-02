import 'package:cemear/views/assinatura.dart';
import 'package:cemear/views/confirmacaoEntrega.dart';
import 'package:cemear/views/home.dart';
import 'package:cemear/views/retorno.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue
    ),
    routes: {
      "/":(context) => Home(),
      "/assinatura":(context) => Assinatura(),
      "/confirmacaoEntrega":(context) => confirmacaoEntrega(),
      "/retorno":(context) => retorno()

    },
  ));
}
