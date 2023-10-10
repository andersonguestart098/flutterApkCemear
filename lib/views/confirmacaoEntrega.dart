import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../components/multiplasNotas.dart';
import "package:http/http.dart" as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';


class ConfirmacaoEntrega extends StatefulWidget {

  const ConfirmacaoEntrega({ super.key });

  @override
  State<ConfirmacaoEntrega> createState() => _ConfirmacaoEntregaState();
}

class _ConfirmacaoEntregaState extends State<ConfirmacaoEntrega> {
  final notaFiscalEC = TextEditingController();
  final obs = TextEditingController();
  final cidade = TextEditingController();
  final entregaConcluida = TextEditingController();
  String? valorDropdownEntrega;
  List<String?> imagemPath = [];
  String? dropDownmotorista;
    bool isLoading = false;
    String url = "";


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
    final formKey = GlobalKey<FormState>();
     
    
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
                    if (formKey.currentState!.validate() && imageFileList != null) {
                          final response = await http.get(Uri.parse("https://pastebin.com/raw/MjGcv5Q7"));
                          final dataRes =jsonDecode(response.body);
                          final String urlNgrok = dataRes["url"];
                          var data = "";
                          
                              final String url = urlNgrok; 
                          
                              final dateNoFormated = DateTime.now();
                              final date = "${dateNoFormated.day}${dateNoFormated.month}${dateNoFormated.year}${dateNoFormated.hour}${dateNoFormated.minute}${dateNoFormated.second}";
                              var arrDateNameFile = [];
                              
                              final String apiUrl = '${urlNgrok}image?name=$date&setor=confirmacaoEntrega';
                              
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
                            
           
                            await http.post(Uri.parse(url),
                                headers: {
                                  "ngrok-skip-browser-warning": "69420",
                                },
                                body: {
                                  "notaFiscal": valorSemEspaco,
                                  "motorista": dropDownmotorista ?? "",
                                  "cidade": cidade.text,
                                  "images": arrDateNameFile.toString().replaceAll("[","").replaceAll("]",""),
                                  "entregaConcluida": valorDropdownEntrega ?? "",
                                  "obs": obs.text.isEmpty ? "Nenhuma observação" : obs.text,
                                  "setor": "confirmacao entrega",
                                });

                                  }
                                }
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.white),
                                      Text("Enviado com sucesso!", style: TextStyle(
                                        color: Colors.white
                                      ),),
                                    ],
                                  )));
                                setState(() {
                                  dropDownmotorista = "";
                                  valorDropdownEntrega = "";
                                   notaFiscalEC.text="";
                                   cidade.text="";
                                   obs.text = "";
                                   isLoading = false;
                                   imageFileList = [];
                                });
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("PREENCHA TODOS OS CAMPOS POR FAVOR!", style: TextStyle(
                                color: Colors.white
                              ),)));
                          }
                    }, child: const Text("Enviar")),
                  ),
                ],
              ),
             ),
           ),
        )
       );
  }
}


