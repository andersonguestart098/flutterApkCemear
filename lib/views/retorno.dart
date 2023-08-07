import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import '../components/multiplasNotas.dart';

class Retorno extends StatefulWidget {
  const Retorno({ super.key });

  @override
  State<Retorno> createState() => _RetornoState();
}

class _RetornoState extends State<Retorno> {
  final notaFiscalEC = TextEditingController();
  final hodometroEC = TextEditingController();
  final obsEC = TextEditingController();
  final formKey = GlobalKey<FormState>();


  String valorDropdownPlaca = "";
  DateTime? dataSelect;

  @override
    void dispose() {
      super.dispose();
      notaFiscalEC.dispose();
    }


   @override
   Widget build(BuildContext context) {

       return Scaffold(
           appBar: AppBar(title: const Text('Retorno'),),
           body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MultiplasNotas(
                  label: "Nota Fiscalfu",
                  validador: (valor) {
                      if(valor.isEmpty) {
                        return "Sem Nota fiscal";
                      }
                      if (!RegExp(r'^[\d,]+$').hasMatch(valor)) {
                               return "Use Apenas Números e vírgula";
                      }

                      return null;
                  }, 
                  controller: notaFiscalEC,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder()
                      ),
                      value: valorDropdownPlaca,
                      hint: const Text("Placa"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Preencha o campo responsável";
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem<String>(value: "", enabled: false, child: Text("")),
                        DropdownMenuItem<String>(value: "IWC5261", child: Text("IWC5261")),
                        DropdownMenuItem<String>(value: "JBD7E59", child: Text("JBD7E59")),
                        DropdownMenuItem<String>(value: "IZT1E84", child: Text("IZT1E84")),
                        DropdownMenuItem<String>(value: "IWW7921", child: Text("IWW7921")),
                        DropdownMenuItem<String>(value: "IVO1603", child: Text("IVO1603")),
                        DropdownMenuItem<String>(value: "AZI2E30", child: Text("AZI2E30")),
                        DropdownMenuItem<String>(value: "ITA7784", child: Text("ITA7784")),
                        DropdownMenuItem<String>(value: "IUT9E76", child: Text("IUT9E76")),
                        DropdownMenuItem<String>(value: "IST6840", child: Text("IST6840")),
                        DropdownMenuItem<String>(value: "IVP0G05", child: Text("IVP0G05")),
                        DropdownMenuItem<String>(value: "JBD9H36", child: Text("JBD9H36")),
                        DropdownMenuItem<String>(value: "JBT9A29", child: Text("JBT9A29")),
                        DropdownMenuItem<String>(value: "JBS7F81", child: Text("JBS7F81")),
                        DropdownMenuItem<String>(value: "IXH8706", child: Text("IXH8706")),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          valorDropdownPlaca = value!;
                        });
                      },
                    ),
                  ),
                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: hodometroEC,
                    decoration: const InputDecoration(
                      labelText: "Digite o hodometro",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Preencha a hodometro";
                      }                    
                      return null;
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    var dataSelecionada = await showDatePicker(
                      context: context, 
                      initialDate: DateTime.now(), 
                      firstDate: DateTime.now(), 
                      lastDate: DateTime(3000),
                    );
                    setState(() {
                      dataSelect = dataSelecionada;
                    });
                  }, 
                icon: const Icon(Icons.date_range), label: const Text("Selecione uma Data")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: obsEC,
                    decoration: const InputDecoration(
                      labelText: "Observações",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(onPressed: () async {
                  if (formKey.currentState!.validate() && dataSelect != null) {
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
                                  "placa": valorDropdownPlaca,
                                  "hodometro": hodometroEC.text,
                                  "data": dataSelect.toString(),
                                  "obs": obsEC.text.isEmpty ? "Nenhuma observação" : obsEC.text,
                                  "setor": "retorno"
                                });
                            }
                          }
                  }
                }, child: const Text("Enviar"))
                ],
              ),
            ),
           ),
       );
  }
}