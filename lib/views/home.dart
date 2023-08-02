import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  const Home({ super.key });

   @override
   Widget build(BuildContext context) {
       return Scaffold(
           appBar: AppBar(title: const Text('Home'),),
           body: Center(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Bem-Vind@, Selecione um formulário:",
                    style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50)
                    ),
                    onPressed: (){
                    Navigator.of(context).pushNamed("/assinatura");
                  }, child: Text("Assinatura")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50)
                    ),
                    onPressed: (){
                    Navigator.of(context).pushNamed("/confirmacaoEntrega");
                  }, child: Text("Confirmação de Entrega")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(200, 50)
                    ),
                    onPressed: (){
                    Navigator.of(context).pushNamed("/retorno");
                  }, child: Text("Retorno")),
                )


              ],
              
             ),
           ),
           
       );
  }
}