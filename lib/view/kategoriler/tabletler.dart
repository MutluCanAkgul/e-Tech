import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/anasayfa.dart';
import 'package:flutter_application_1/view/usermenu/user.dart';

class Tabletler extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> _Tabletler();

}

class _Tabletler extends State<Tabletler>{
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(backgroundColor: Colors.orange,title:const Text("Tabletler",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),centerTitle: true,actions: [IconButton(onPressed: (){}, icon:const Icon(Icons.search))]),
    bottomNavigationBar: CurvedNavigationBar(backgroundColor: Colors.white,color: Colors.orange,
    items:[IconButton(onPressed:(){
      Navigator.push(context,MaterialPageRoute(builder:(context)=> Anasayfa()));
    }, icon:const Icon(Icons.home)),
    IconButton(onPressed:(){
      Navigator.pop(context);
    }, icon:const Icon(Icons.menu)),IconButton(onPressed: (){
     Navigator.push(context,MaterialPageRoute(builder:(context)=> UserUI()));
    }, icon:const Icon(Icons.account_circle))
    ]),
  );
  }
  
}