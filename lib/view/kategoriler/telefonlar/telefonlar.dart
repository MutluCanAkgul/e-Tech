import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/anasayfa.dart';
import 'package:flutter_application_1/view/kategoriler/telefonlar/TelefonMarkaFiltre.dart';
import 'package:flutter_application_1/view/kategoriler/urundetay.dart';
import 'package:flutter_application_1/view/usermenu/user.dart';

class Telefonlar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Telefonlar();
}

class _Telefonlar extends State<Telefonlar> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            "Urunler",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ]),
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.orange,
          animationDuration: Duration(milliseconds: 300),height:60,
          items: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Anasayfa()));
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
                icon: const Icon(Icons.account_box))
          ]),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Markalar",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              TelefonMarkalar(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Popüler Ürünler",
                style: TextStyle(fontSize: 15),
              ),
              Urunler()
            ],
          ),
        ),
      ),
    );
  }
}

class TelefonMarkalar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MarkalarState();
}

class _MarkalarState extends State<TelefonMarkalar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Markalar")
          .where(FieldPath.documentId, whereIn: [
        "iH26OlZicMnPoJfMtP81",
        "o73coO8IJADX1xp3GyOf",
        "lzOJQ6x1JrCI3uTQuUN5",
        "hoACsUMA5y21E8ibQlNL",
        "WaepbBVrIBn92q0ULpC4"
      ]).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}"));
        }

        final List<DocumentSnapshot> documents = snapshot.data!.docs;
        return Container(
          height: 90,
          width: 360,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: documents.map((document) {
              var markaId = document.id;
              var imageUrl = document['markaImage'];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarkaDetay(markaId: markaId),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 13.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.fitWidth,
                      height: 60,
                      width: 60,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class Urunler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Urunler();
}

class _Urunler extends State<Urunler> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Urunler')
            .where('tur', isEqualTo: 'telefon')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.5,
              ),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var document = documents[index];
                var telefonAd = document['adi'];
                var telefonDegeer = document['deger'];
                var telefonImage1 = document['imageUrl1'];
                var urunId = document.id;
                var indirimliMi = document['indirimliMi'];
                var indirimFiyat = document['indirimfiyat'];
                var ortalamaPuan = document['ortalamaPuan'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UrunDetay(urunId: urunId)),
                    );
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
                                image: NetworkImage(telefonImage1),
                                fit: BoxFit.fitWidth,
                              ),
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
                                  telefonAd,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              const SizedBox(height: 5),
                                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(5, (index) {
                                                return Icon(
                                                  index < ortalamaPuan ? Icons.star : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 20, 
                                                );
                                              }),
                                            ),
                                            Text("(${ortalamaPuan})")
                                          ],
                                        ),
                              Center(
                                child: indirimliMi == 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "$indirimFiyat TL",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.orange),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "$telefonDegeer TL",
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
                                        "$telefonDegeer TL",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: Colors.orange),
                                      ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4)),
                                  child: const Text("   Kargo Bedava   "),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}