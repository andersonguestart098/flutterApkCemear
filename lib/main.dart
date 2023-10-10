
import 'package:cemear/views/assinatura.dart';
import 'package:cemear/views/confirmacaoEntrega.dart';
import 'package:cemear/views/home.dart';
import 'package:cemear/views/retorno.dart';
import 'package:cemear/views/saida.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




void main() async {

  
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue
    ),
    routes: {
      "/":(context) => Home(),
      "/assinatura":(context) => Assinatura(),
      "/confirmacaoEntrega":(context) => const ConfirmacaoEntrega(),
      "/retorno":(context) => const Retorno(),
      "/saida":(context) => const Saida()
    },
  ));
}
