import 'package:flutter/material.dart';

class TelevizyonMarkaFiltre extends StatefulWidget{
  final String markaId;
  const TelevizyonMarkaFiltre({Key? key , required this.markaId}) : super(key: key);
  @override
  State<StatefulWidget> createState()=> _TelevizyonMarkaFiltre();  
}

class _TelevizyonMarkaFiltre extends State<TelevizyonMarkaFiltre>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(title: const Text("Ürünler"),centerTitle: true,actions: [IconButton(onPressed:(){

    }, icon:const Icon(Icons.shopping_basket))],backgroundColor: Colors.orange,),
   );
  }
  
}