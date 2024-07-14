import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/anasayfa.dart';
import 'package:flutter_application_1/view/kategoriler/televizyonlar/TelevizyonlarMarkaFiltre.dart';
import 'package:flutter_application_1/view/kategoriler/urundetay.dart';
import 'package:flutter_application_1/view/usermenu/user.dart';

class Televizyonlar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Televizyonlar();
}

class _Televizyonlar extends State<Televizyonlar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Televizyonlar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.orange,height:60,
          items: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Anasayfa()));
                },
                icon: const Icon(Icons.home)),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.menu)),
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserUI()));
                },
                icon: const Icon(Icons.account_circle))
          ]),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Markalar",
                style: TextStyle(fontSize: 18),
              ),
              TelevizyonMarkalar(),
              SizedBox(height: 20),
              TelevizyonUrunler(),
            ],
          ),
        ),
      ),
    );
  }
}

class TelevizyonMarkalar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Markalar();
}

class _Markalar extends State<TelevizyonMarkalar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Markalar')
            .where(FieldPath.documentId,
                whereIn: ["o73coO8IJADX1xp3GyOf", "tcl", "lg", "phillips "])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return Container(
            height: 90,
            width: 300,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: documents.map((document) {
                var markaId = document.id;
                var markaImage = document['markaImage'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TelevizyonMarkaFiltre(markaId: markaId)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 13),
                    child: ClipRRect(
                      child: Image.network(
                        markaImage,
                        fit: BoxFit.contain,
                        height: 60,
                        width: 80,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        });
  }
}

class TelevizyonUrunler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TelevizyonlarUrunler();
}

class _TelevizyonlarUrunler extends State<TelevizyonUrunler> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Urunler')
            .where('tur', isEqualTo: 'televizyon')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.5,
                  crossAxisSpacing: 8.0),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var document = documents[index];
                var markaAd = document['adi'];
                var markaResim = document['markaImage'];
                var markaDeger = document['deger'];
                var indirimliMi = document['indirimliMi'];
                var indirimfiyat = document['indirimfiyat'];
                var urunId = document.id;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UrunDetay(urunId: urunId)));
                  },
                  child: Card(
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(markaResim),
                                  fit: BoxFit.fitWidth),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  markaAd,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Center(
                                child: indirimliMi == 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$indirimfiyat TL",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.orange),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "$markaDeger TL",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey,
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "$markaDeger TL",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange),
                                      ),
                              ),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Text(" Kargo Bedava "),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }
}