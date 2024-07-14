import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/kategoriler/urundetay.dart';

class Favori extends StatefulWidget {
  @override
  State<Favori> createState() => _FavoriState();
}

class _FavoriState extends State<Favori> {
 
 final String kulId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favori Ürünlerim",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Favori")
            .where('kulId', isEqualTo: kulId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Favori Ürününüz Bulunmamaktadır"));
          }
          var favoriUrunler = snapshot.data!.docs;
          return ListView.builder(
            itemCount: favoriUrunler.length,
            itemBuilder: (context, index) {
              var favoriUrun = favoriUrunler[index];
              var urunId = favoriUrun['urunId'];
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("Urunler")
                    .doc(urunId)
                    .get(),
                builder: (context, urunSnapshot) {
                  if (!urunSnapshot.hasData) {
                    return const ListTile(
                      title: Text("Yükleniyor..."),
                    );
                  }
                  var urunData = urunSnapshot.data!.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: urunData['imageUrl1'] != ""
                        ? Image.network(urunData['imageUrl1'],fit: BoxFit.cover,)
                        : Container(),
                    title: Text(urunData['adi'],style: const TextStyle(fontSize: 20),),
                    subtitle: Text(urunData['indirimliMi'] == 1
                        ? "${urunData['indirimfiyat']} TL"
                        : "${urunData['deger']} TL",style:const TextStyle(color: Colors.orange),),
                        trailing:IconButton(onPressed:(){
                          FirebaseFirestore.instance.collection('Favori').doc(favoriUrun.id).delete();
                        }, icon: const Icon(Icons.delete)),onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder:(context)=> UrunDetay(urunId:urunId)));
                        },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
