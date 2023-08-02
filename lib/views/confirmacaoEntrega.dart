import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../components/multiplasNotas.dart';
import "package:http/http.dart" as http;

class confirmacaoEntrega extends StatefulWidget {

  const confirmacaoEntrega({ super.key });

  @override
  State<confirmacaoEntrega> createState() => _confirmacaoEntregaState();
}

class _confirmacaoEntregaState extends State<confirmacaoEntrega> {
  bool desenhado = false;
  final SignatureController assinaturaController = SignatureController(
    exportBackgroundColor: Colors.white,
    strokeCap: StrokeCap.round,
    
  );
  final notaFiscalEC = TextEditingController();
  String? valorDropdown;

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
                      decoration: InputDecoration(
                        border: OutlineInputBorder()
                      ),
                      value: valorDropdown,
                      hint: Text("Motorista"),
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
                          valorDropdown = value!;
                        });
                      },
                    ),
                  ),


                   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Digite a cidade",
                      border: OutlineInputBorder(),
                    ),
                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha o campo do motorista";
                      }
                      return null;
                    },
                  ),
                ),


                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: OutlineInputBorder()
                      ),
                      value: valorDropdown,
                      hint: Text("entregaConcluida"),
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
                          valorDropdown = value!;
                        });
                      },
                    ),
                  ),


                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Observações",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0), 
                    child: ElevatedButton(onPressed: () async {
                      if (formKey.currentState!.validate() && desenhado) {
                          final base64 = await assinaturaController.toPngBytes();
                          final imageBase64 = "data:image/png;base64,${base64Encode(base64!)}";
                          final List<String> valorNotaFiscal = notaFiscalEC.text.split(",");
                          for(String i in valorNotaFiscal) {
                            final String valorSemEspaco = i.trim();
                            if (valorSemEspaco.isNotEmpty) {
                              await http.post(Uri.parse("https://cemear-api.vercel.app/registrarAssinatura"), 
                              body: {
                                "notaFiscal": valorSemEspaco,
                                "responsavel": valorDropdown,
                                "assinatura_img": imageBase64
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