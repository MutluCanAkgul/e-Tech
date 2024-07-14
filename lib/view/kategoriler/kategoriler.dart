import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_1/view/anasayfa.dart';
import 'package:flutter_application_1/view/kategoriler/laptoplar/laptoplar.dart';
import 'package:flutter_application_1/view/kategoriler/tabletler.dart';
import 'package:flutter_application_1/view/kategoriler/televizyonlar/televizyonlar.dart';
import 'package:flutter_application_1/view/kategoriler/telefonlar/telefonlar.dart';
import 'package:flutter_application_1/view/usermenu/user.dart';

class Kategori extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> _Kategori();
   
}

class _Kategori  extends State<Kategori>{

  @override
  Widget build(BuildContext context) {
    
  return Scaffold(
  appBar: AppBar(backgroundColor: Colors.orange,title: const Text("Kategoriler",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),centerTitle: true,actions: [IconButton(onPressed:(){}, icon:const Icon(Icons.search))],),
  bottomNavigationBar: CurvedNavigationBar(height: 60,backgroundColor: Colors.white,color: Colors.orange,items:[IconButton(onPressed:(){
    Navigator.pop(context,MaterialPageRoute(builder:(context)=> Anasayfa()));
  }, icon:const Icon(Icons.home)),IconButton(onPressed:(){}, icon:const Icon(Icons.menu)),IconButton(onPressed: (){
    Navigator.push(context,MaterialPageRoute(builder:(context)=>UserUI()));
  }, icon:const Icon(Icons.account_circle))]) ,
 
  body: ListView(padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),children: [
   Container(height: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange),
      child: ListTile(title:const Padding(
        padding: EdgeInsets.all(10.0),
        child:  Text("Telefonlar",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,),),
      ),trailing: const Icon(Icons.smartphone),onTap:(){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> Telefonlar()));
      },),
    ),const SizedBox(height: 15,),
    Container(height: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange),child: ListTile(onTap:(){
      Navigator.push(context, MaterialPageRoute(builder:(context)=> Laptoplar()));
    } ,title:const Padding(
      padding: EdgeInsets.all(10.0),
      child: Text("Laptoplar",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
    ),trailing:const Icon(Icons.laptop),),),
    const SizedBox(height: 15,),
    Container(height: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange),child: ListTile(onTap:(){
      Navigator.push(context, MaterialPageRoute(builder:(context)=> Tabletler()));
    } ,title:const Padding(
      padding: EdgeInsets.all(10.0),
      child: Text("Tabletler",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
    ),trailing:const Icon(Icons.tab),),),
    const SizedBox(height: 15,),
    Container(height: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange),child: ListTile(onTap:(){
      Navigator.push(context, MaterialPageRoute(builder:(context)=> Televizyonlar()));
    } ,title:const Padding(
      padding: EdgeInsets.all(10.0),
      child: Text("Televizyonlar",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
    ),trailing:const Icon(Icons.tv),),),
  ],)
  );
  
  }
}