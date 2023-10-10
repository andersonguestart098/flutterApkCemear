import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../components/multiplasNotas.dart';

class Saida extends StatefulWidget {
  const Saida({ super.key });

  @override
  State<Saida> createState() => _SaidaState();
}

class _SaidaState extends State<Saida> {
  final notaFiscalEC = TextEditingController();
  final hodometroEC = TextEditingController();
  final obsEC = TextEditingController();
  final codEntrega = TextEditingController();
  final cidade = TextEditingController();
  final formKey = GlobalKey<FormState>();


  String valorDropdownPlaca = "";
  String valorDropdownConferente = "";
  String valorDropdownMotorista = "";
  DateTime? dataSelect;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    codEntrega.text = (Random().nextInt(9999)+1000).toString();
  }

  @override
    void dispose() {
      super.dispose();
      notaFiscalEC.dispose();
    }

    final ImagePicker imagePicker = ImagePicker();
    List<XFile>? imageFileList = [];

      void selectImages() async {
         final List<XFile> selectedImages = await 
                imagePicker.pickMultiImage();
           if (selectedImages.isNotEmpty) {
              imageFileList!.addAll(selectedImages);
           }
          setState((){});
      }


   @override
   Widget build(BuildContext context) {

       return Scaffold(
           appBar: AppBar(title: const Text('Carregamento do caminhão'),),
           body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: codEntrega,
                      enabled: false,
                      decoration: const InputDecoration(
                        
                        labelText: "Código da entrega",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
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
                  }, 
                  controller: notaFiscalEC,
                  ),
                  ElevatedButton(
                     onPressed: () {
                       selectImages();
                   },
                  child: Text('Select Images'),
                      ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: imageFileList?.map((imageFile) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.file(
                            File(imageFile.path),
                            fit: BoxFit.cover,
                            width: 140,
                            height: 140,
                          ),
                        );
                      }).toList() ?? [],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Conferente:",
                        border: OutlineInputBorder()
                      ),
                      
                      value: valorDropdownConferente,
                      hint: const Text("Conferente:"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Preencha o campo conferente";
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem<String>(value: "", enabled: false, child: Text("")),
                        DropdownMenuItem<String>(value: "MAX", child: Text("MAX")),
                        DropdownMenuItem<String>(value: "EVERTON", child: Text("EVERTON")),
                        DropdownMenuItem<String>(value: "EDUARDO", child: Text("EDUARDO")),
                        DropdownMenuItem<String>(value: "CRISTIANO D.", child: Text("CRISTIANO D")),
                        DropdownMenuItem<String>(value: "MATHEUS", child: Text("MATHEUS")),
                        DropdownMenuItem<String>(value: "MANOEL", child: Text("MANOEL"))
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          valorDropdownConferente = value!;
                        });
                      },
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Placa:",
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
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Motorista:",
                        border: OutlineInputBorder()
                      ),
                      value: valorDropdownMotorista,
                      hint: const Text("Motorista"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Preencha o campo responsável";
                        }
                        return null;
                      },
                      items: const [
                        DropdownMenuItem<String>(value: "", enabled: false, child: Text("")),
                        DropdownMenuItem<String>(value: "DIONATHA", child: Text("DIONATHA")),
                        DropdownMenuItem<String>(value: "DOUGLAS", child: Text("DOUGLAS")),
                        DropdownMenuItem<String>(value: "IGON", child: Text("IGON")),
                        DropdownMenuItem<String>(value: "JULIANO", child: Text("JULIANO")),
                        DropdownMenuItem<String>(value: "MATHEUS", child: Text("MATHEUS")),
                        DropdownMenuItem<String>(value: "PAULO ALEXANDRE", child: Text("PAULO ALEXANDRE")),
                        DropdownMenuItem<String>(value: "VANDERLEI", child: Text("VANDERLEI")),
                        DropdownMenuItem<String>(value: "VILNEI", child: Text("VILNEI")),
                        DropdownMenuItem<String>(value: "MAX", child: Text("MAX")),
                        DropdownMenuItem<String>(value: "CRISTIANO", child: Text("CRISTIANO")),
                        DropdownMenuItem<String>(value: "WILLIAM", child: Text("WILLIAM"))
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          valorDropdownMotorista = value!;
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
                      if (!RegExp(r'^[\d,]+$').hasMatch(value!)) {
                               return "Use Apenas Números ";
                      }                
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: cidade,
                    decoration: const InputDecoration(
                      labelText: "Cidade(s) Destino",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Preencha a cidade destino";
                      }                    
                      return null;
                    },
                  ),
                ),

               
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
                ElevatedButton(onPressed:
                isLoading ?
                (){} :
                 () async {
                  if (formKey.currentState!.validate() && imageFileList != null) {
                    setState(() {
                      isLoading = true;
                    });
                  final response = await http.get(Uri.parse("https://pastebin.com/raw/MjGcv5Q7"));
                  final dataRes =jsonDecode(response.body);
                  final String urlNgrok = dataRes["url"];

                  final dateNoFormated = DateTime.now();
                  final date = "${dateNoFormated.day}${dateNoFormated.month}${dateNoFormated.year}${dateNoFormated.hour}${dateNoFormated.minute}${dateNoFormated.second}";
                  var arrDateNameFile = [];
                  final String apiUrl = '${urlNgrok}image?name=$date&setor=saida';

                  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
                              request.headers['ngrok-skip-browser-warning'] = '69420';

                              var count = 1;
                              for (XFile imageFile in imageFileList!) {
                                arrDateNameFile.add("${date}_$count.png");
                                final File file = File(imageFile.path);
                                final String fileName = file.path.split('/').last;

                                request.files.add(
                                  await http.MultipartFile.fromPath(
                                    'files', 
                                    file.path,
                                    filename: fileName,
                                    contentType:  MediaType("image", "png")
                                  ),
                                );
                                count++;
                              }

                              var responseImg = await request.send();

                              if (responseImg.statusCode == 200) {
                                print('Imagens enviadas com sucesso.');
                              } else {
                                print('Erro ao enviar imagens. Código de status: ${responseImg.statusCode}');
                              }


                    final List<String> valorNotaFiscal = notaFiscalEC.text.split(",");
                          for(String i in valorNotaFiscal) {
                            final String valorSemEspaco = i.trim();
                            if (valorSemEspaco.isNotEmpty) {
                              final String url = urlNgrok;

                              await http.post(Uri.parse(url),
                                  headers: {
                                    "ngrok-skip-browser-warning": "69420",
                                  }, 
                                  body: {
                                    "notaFiscal": valorSemEspaco,
                                    "nomeConferente": valorDropdownConferente,
                                    "placa": valorDropdownPlaca,
                                    "motorista": valorDropdownMotorista,
                                    "codigoEntrega": codEntrega.text,
                                    "hodometro": hodometroEC.text,
                                    "cidadeDestino": cidade.text,
                                    "data": dataSelect.toString(),
                                    "images": arrDateNameFile.toString().replaceAll("[","").replaceAll("]",""),
                                    "obs": obsEC.text.isEmpty ? "Nenhuma observação" : obsEC.text,
                                    "setor": "saida"
                                  });

                            }
                          }
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle),
                                      Text("Enviado com sucesso!"),
                                    ],
                                  )));
                                setState(() {
                                  valorDropdownPlaca = "";
                                  codEntrega.text = (Random().nextInt(9999)+1000).toString();
                                  dataSelect = null;
                                  obsEC.text = "";
                                  notaFiscalEC.text="";
                                  valorDropdownMotorista = "";
                                  valorDropdownConferente = "";
                                  cidade.text="";
                                  hodometroEC.text="";
                                  isLoading=false;
                                  imageFileList = [];
                                });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("PREENCHA TODOS OS CAMPOS POR FAVOR!", style: TextStyle(
                                color: Colors.white
                              ),)));
                  }
                }, child: isLoading ? const CircularProgressIndicator(
                  color: Colors.white,
                ) : const Text("Enviar"))
                ],
              ),
            ),
           ),
       );
  }
}