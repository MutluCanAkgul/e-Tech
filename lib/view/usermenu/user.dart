import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/anasayfa.dart';
import 'package:flutter_application_1/view/kategoriler/kategoriler.dart';
import 'package:flutter_application_1/view/usermenu/kullanici.dart';
import 'package:flutter_application_1/view/usermenu/adresbilgileri.dart';
import 'package:flutter_application_1/view/usermenu/favorilerim.dart';

class UserUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> _UserUI(); 
 
}
class _UserUI extends State<UserUI>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(actions: [IconButton(onPressed:(){}, icon:const Icon(Icons.search) )],
    title:const Text("Hesabım",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),centerTitle: true,backgroundColor: Colors.orange,),
    bottomNavigationBar: CurvedNavigationBar(height: 60,color:Colors.orange,animationDuration:const Duration(milliseconds: 300),backgroundColor: Colors.white,items:[IconButton(onPressed:(){
      Navigator.pop(context,MaterialPageRoute(builder:(context)=> const Anasayfa()));
    }, icon:const Icon(Icons.home)),
    IconButton(onPressed:(){
      Navigator.push(context,MaterialPageRoute(builder:(context)=> Kategori()));
    }, icon:const Icon(Icons.menu)),IconButton(onPressed:(){

    }, icon:const Icon(Icons.account_circle))]),

    body: ListView(padding:const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
    children: [Container(height: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.blue,),
    child: ListTile(title:const Padding(padding:EdgeInsets.all(10.0),child: Text("Siparişlerim",style:TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),),trailing:  const Icon(Icons.add_shopping_cart_rounded),onTap: (){
      //Siparişler ile ilgili sayfa yönlendirmesi yapılacak
    },),),const SizedBox(height: 10,),
     
    Container(height: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.blue),child: ListTile(title:const Padding(padding: EdgeInsets.all(10.0),child: Text("Adres Bilgilerim",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),) ,),trailing: const Icon(Icons.location_on),onTap: (){
      Navigator.push(context, MaterialPageRoute(builder:(context)=> AdresBilgileri()));
    },),),
    const SizedBox(height: 10,),
    Container(height: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.blue,),child: ListTile(title: const Padding(padding: EdgeInsets.all(10.0),child: Text("Favori Ürünlerim",style:TextStyle(fontSize: 22,fontWeight: FontWeight.w600)),),trailing: const Icon(Icons.heat_pump_sharp),onTap:(){
      Navigator.push(context, MaterialPageRoute(builder:(context)=> Favori()));
    },)),
    const SizedBox(height: 10,),
    Container(height: 70,decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.white,
    border: Border.all(color: Colors.black)),child: ListTile(title: const Padding(padding: EdgeInsets.all(10.0),
    child: Text("Çıkış Yap",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: Colors.red),) ,),
    trailing: const Icon(Icons.arrow_back),onTap: (){
      Navigator.push(context,MaterialPageRoute(builder:(context)=> User()));
    },),)],),
   );
  }
  
}