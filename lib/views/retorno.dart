import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../components/multiplasNotas.dart';
import "package:http/http.dart" as http;

class retorno extends StatefulWidget {

  const retorno({ super.key });

  @override
  State<retorno> createState() => _retornoState();
}

class _retornoState extends State<retorno> {
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
           appBar: AppBar(title: const Text('Retorno'),),
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
                      hint: Text("placa"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Preencha a placa";
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
                        DropdownMenuItem<String>(value: "IUT9476", child: Text("IUT9476")),
                        DropdownMenuItem<String>(value: "IST6840", child: Text("IST6840")),
                        DropdownMenuItem<String>(value: "IVP0G05", child: Text("IVP0G05")),
                        DropdownMenuItem<String>(value: "JBD9H36", child: Text("JBD9H36")),
                        DropdownMenuItem<String>(value: "IXH8706", child: Text("IXH8706"))
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
                      labelText: "Hodometro",
                      border: OutlineInputBorder(),
                    ),
                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Preencha o campo hodometro";
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Data de retorno:"),
                  ),

                
                  ElevatedButton(onPressed: () async{
                    DateTime? pickedDate = await showDatePicker(
    context: context, //context of current state
    initialDate: DateTime.now(),
    firstDate: DateTime(2000), //DateTime.now() - not to allow to choose before today.
    lastDate: DateTime(2101)
);

if(pickedDate != null ){
    print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
    
}else{
    print("Date is not selected");
}
                  }, child: Text("selecione uma data de retorno")),


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