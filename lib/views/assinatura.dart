import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../components/multiplasNotas.dart';
import "package:http/http.dart" as http;

class Assinatura extends StatefulWidget {

  const Assinatura({ super.key });

  @override
  State<Assinatura> createState() => _AssinaturaState();
}

class _AssinaturaState extends State<Assinatura> {
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
           appBar: AppBar(title: const Text('assinatura'),),
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
                      value: valorDropdown,
                      hint: const Text("Responsável"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Preencha o campo responsável";
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem<String>(value: "", enabled: false, child: Text("")),
                        DropdownMenuItem<String>(value: "Dieimes", child: Text("Dieimes")),
                        DropdownMenuItem<String>(value: "Cristiano S.", child: Text("Cristiano S.")),
                        DropdownMenuItem<String>(value: "Cristiano D.", child: Text("Cristiano D.")),
                        DropdownMenuItem<String>(value: "Max", child: Text("Max")),
                        DropdownMenuItem<String>(value: "Matheus", child: Text("Matheus")),
                        DropdownMenuItem<String>(value: "Manoel", child: Text("Manoel")),
                        DropdownMenuItem<String>(value: "Eduardo", child: Text("Eduardo")),
                        DropdownMenuItem<String>(value: "Everton", child: Text("Everton"))
                      ],
                      onChanged: (String? value) { // Especifique o tipo do parâmetro onChanged como String?
                        setState(() {
                          valorDropdown = value!;
                        });
                      },
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Sua Assinatura:"),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Signature(controller: assinaturaController, height: 300,
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
                              final response = await http.get(Uri.parse("https://cemear-api.vercel.app"));
                              final data =jsonDecode(response.body);
                              final String url = data["url"];

                              await http.post(Uri.parse(url),
                                headers: {
                                  "ngrok-skip-browser-warning": "69420",
                                }, 
                                body: {
                                  "notaFiscal": valorSemEspaco,
                                  "responsavel": valorDropdown,
                                  "assinatura_img": imageBase64,
                                  "setor": "assinatura",
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