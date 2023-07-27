import 'package:flutter/material.dart';

class MultiplasNotas extends StatefulWidget {
  final String label;
  final dynamic Function(String) validador;
  final TextEditingController controller;

 MultiplasNotas({ super.key, required this.label, required this.validador, required this.controller});

  @override
  State<MultiplasNotas> createState() => _MultiplasNotasState();
}

class _MultiplasNotasState extends State<MultiplasNotas> {

    
   @override
   Widget build(BuildContext context) {
        
    String valorDoInput = widget.controller.text;


       return Column(
         children: [
           Padding(
              padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            validator: (valor) => widget.validador(valor!),
                            controller: widget.controller,
                            onChanged: (value) {
                                setState(() {
                                    valorDoInput = value;
                                });
                            },
                          decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: widget.label,
                          )
                        ),
                      ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: [
                                for(String i in valorDoInput.split(",")) 
                                Container(color: Colors.blue, margin: const EdgeInsets.all(8), 
                                child: Center(child: Text(i)),
                                ),
                            ],
                        )
                    )
                      
         ],
       );
  }
}