import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../components/multiplasNotas.dart';
import "package:http/http.dart" as http;

class ConfirmacaoEntrega extends StatefulWidget {

  const ConfirmacaoEntrega({ super.key });

  @override
  State<ConfirmacaoEntrega> createState() => _ConfirmacaoEntregaState();
}

class _ConfirmacaoEntregaState extends State<ConfirmacaoEntrega> {
  bool desenhado = false;
  final SignatureController assinaturaController = SignatureController(
    exportBackgroundColor: Colors.white,
    strokeCap: StrokeCap.round,
    
  );
  final notaFiscalEC = TextEditingController();
  final obs = TextEditingController();
  final cidade = TextEditingController();
  final entregaConcluida = TextEditingController();
  String? valorDropdownEntrega;
  String? dropDownmotorista;

  @override
    void dispose() {
      // TODO: implement dispose
      super.dispose();
      assinaturaController.dispose();
    }


   @override
   Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    setState(() {
          assinaturaController.onDrawStart = () {
              desenhado = true;
    };
        });
    
    
       return Scaffold(
           appBar: AppBar(title: const Text('Confirmação de Entrega'),),
           body: Padding(
             padding: const EdgeInsets.all(8.0),
             child:  SingleChildScrollView(
             child: Form(
              key: formKey,
              child: Column(
                children: [
                  MultiplasNotas(
                    label: "Nota Fiscal", 
                    validador: (valor) {
                      if(valor.isEmpty) {
                        return "Sem Nota fiscal";
                      }
                      if (!RegExp(r'^[\d,]+$').hasMatch(valor)) {
                               return "Use Apenas Números e vírgula";
                      }

                      return null;
                  }, controller: notaFiscalEC,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder()
                      ),
                      
                      value: dropDownmotorista,
                      hint: const Text("Motorista"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Preencha o campo motorista";
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem<String>(value: "", enabled: false, child: Text("")),
                        DropdownMenuItem<String>(value: "ALEXANDRE", child: Text("ALEXANDRE")),
                        DropdownMenuItem<String>(value: "DIONATHAN", child: Text("DIONATHAN")),
                        DropdownMenuItem<String>(value: "DOUGLAS", child: Text("DOUGLAS")),
                        DropdownMenuItem<String>(value: "IGON", child: Text("IGON")),
                        DropdownMenuItem<String>(value: "JULIANO", child: Text("JULIANO")),
                        DropdownMenuItem<String>(value: "MATHEUS", child: Text("MATHEUS")),
                        DropdownMenuItem<String>(value: "PAULO", child: Text("PAULO")),
                        DropdownMenuItem<String>(value: "VANDERLEI", child: Text("VANDERLEI")),
                        DropdownMenuItem<String>(value: "VILNEI", child: Text("VILNEI")),
                        DropdownMenuItem<String>(value: "MAX", child: Text("MAX")),
                        DropdownMenuItem<String>(value: "PAULO VITOR", child: Text("PAULO VITOR")),
                        DropdownMenuItem<String>(value: "CRISTIANO", child: Text("CRISTIANO")),
                        DropdownMenuItem<String>(value: "WILLIAM", child: Text("WILLIAM")),
                        DropdownMenuItem<String>(value: "PAULO ALEXANDRE", child: Text("PAULO ALEXANDRE"))
                      ],
                      onChanged: (String? value) { // Especifique o tipo do parâmetro onChanged como String?
                        setState(() {
                          dropDownmotorista = value!;
                        });
                      },
                    ),
                  ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: cidade,
                    decoration: const InputDecoration(
                      labelText: "Digite a cidade",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if(value != null && value.isEmpty){
                        return "Digite a cidade";
                      }
                      return null;
                    },
                  ),
                ),


                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder()
                      ),
                      value: valorDropdownEntrega,
                      hint: const Text("entregaConcluida"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Entrega foi concluida?";
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem<String>(value: "", enabled: false, child: Text("")),
                        DropdownMenuItem<String>(value: "ENTREGUE", child: Text("ENTREGUE")),
                        DropdownMenuItem<String>(value: "NAO ENTREGUE", child: Text("NAO ENTREGUE"))
                      ],
                      onChanged: (String? value) { // Especifique o tipo do parâmetro onChanged como String?
                        setState(() {
                          valorDropdownEntrega = value!;
                        });
                      },
                    ),
                  ),


                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: obs,
                    decoration: const InputDecoration(
                      labelText: "Observações",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0), 
                    child: ElevatedButton(onPressed: () async {
                      if (formKey.currentState!.validate()) {

                          final List<String> valorNotaFiscal = notaFiscalEC.text.split(",");
                          for(String i in valorNotaFiscal) {
                            final String valorSemEspaco = i.trim();
                            if (valorSemEspaco.isNotEmpty) {
                            final response = await http.get(Uri.parse("https://cemear-api.vercel.app"));
                              final data =jsonDecode(response.body);
                              final String url = data["url"];
                            await http.post(Uri.parse(url),
                                headers: {
                                  "ngrok-skip-browser-warning": "69420",
                                }, 
                                body: {
                                  "notaFiscal": valorSemEspaco,
                                  "motorista": dropDownmotorista,
                                  "cidade": cidade.text,
                                  "entregaConcluida": valorDropdownEntrega,
                                  "obs": obs.text.isEmpty ? "Nenhuma observação" : obs.text,
                                  
                                  "setor": "confirmacao entrega",
                                });
                            }
                          }
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("PREENCHA TODOS OS CAMPOS POR FAVOR!")));
                          }
                    }, child: const Text("Enviar"),),
                  ),
                ],
              ),
             ),
           ),
       )
       );
  }
}