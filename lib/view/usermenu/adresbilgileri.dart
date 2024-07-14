
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/anasayfa.dart';
import 'package:flutter_application_1/view/kategoriler/kategoriler.dart';
import 'package:flutter_application_1/view/usermenu/adresduzenle.dart';
import 'package:flutter_application_1/view/usermenu/adresekle.dart';

class AdresBilgileri extends StatefulWidget{
  
  

  @override
  State<StatefulWidget> createState()=> _AdresBilgileri();
}
class _AdresBilgileri extends State<AdresBilgileri>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [IconButton(onPressed:(){
        Navigator.push(context, MaterialPageRoute(builder:(context)=> AdresEkle()));
      }, icon: const Icon(Icons.add,size: 33))],
      title:const Text("Adres Bilgilerim",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),centerTitle: true,
      backgroundColor: Colors.orange,),

       bottomNavigationBar: CurvedNavigationBar(color:Colors.orange,animationDuration:const Duration(milliseconds: 300),backgroundColor: Colors.white,items:[IconButton(onPressed:(){
      Navigator.pop(context,MaterialPageRoute(builder:(context)=> const Anasayfa()));
    }, icon:const Icon(Icons.home)),
    IconButton(onPressed:(){
      Navigator.push(context,MaterialPageRoute(builder:(context)=> Kategori()));
    }, icon:const Icon(Icons.menu)),IconButton(onPressed:(){

    }, icon:const Icon(Icons.account_circle))]),

     body: StreamBuilder(
  stream: FirebaseFirestore.instance.collection('Adresler').where('kulId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final adresBasligi = doc['baslik'];
            final sehir = doc['sehir'];
            final ilce = doc['ilce'];
            final adres = doc['adres'];
            final telefon = doc['telNo'];
          
            return Dismissible(
              key: Key(doc.id),
              direction: DismissDirection.horizontal,
              background: Container(decoration:const BoxDecoration(borderRadius: BorderRadius.horizontal(left: Radius.circular(30),right: Radius.circular(0)),color: Colors.red),     
                child:const Align(
                  alignment: Alignment.centerRight ,
                  child: Padding(padding: EdgeInsets.only(right: 12.0), child: Icon(Icons.delete, color: Colors.white)),
                ),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  
                  return false; // Silme işlemini engeller
                } else {
                  bool deleteConfirmation = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Uyarı!"),
                      content: const Text("Bu adresi silmek istediğinize emin misiniz?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text("İptal"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            "Sil",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  return deleteConfirmation; // Silme işlemini onaylar
                }
              },
              onDismissed: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  await FirebaseFirestore.instance.collection("Adresler").doc(doc.id).delete();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.lightBlue, borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(adresBasligi, style: const TextStyle(fontSize: 18)),
                      subtitle: Text('$sehir $ilce\n$adres\nTelefon: $telefon'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdresDuzenle(
                                adresId: doc.id,
                                baslik: adresBasligi,
                                sehir: sehir,
                                ilce: ilce,
                                adres: adres,
                                telNo: telefon,
                                
                              ),
                            ),
                          ); 
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      } else {
        return Center(child: Text('Henüz adres bilgisi yok.'));
      }
    }
  },
),
    );
  }
  
}