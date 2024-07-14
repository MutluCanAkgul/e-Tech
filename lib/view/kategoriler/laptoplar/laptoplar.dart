import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/anasayfa.dart';
import 'package:flutter_application_1/view/kategoriler/laptoplar/Laptopfiltre.dart';
import 'package:flutter_application_1/view/kategoriler/urundetay.dart';
import 'package:flutter_application_1/view/usermenu/user.dart';

class Laptoplar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Laptoplar();
}

class _Laptoplar extends State<Laptoplar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange,
          title: const Text(
            "Laptoplar",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ]),
      bottomNavigationBar: CurvedNavigationBar(height:60,
          backgroundColor: Colors.white,
          color: Colors.orange,
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
              LaptopMarkalar(),
              const SizedBox(
                height: 10,
              ),
              const Text("Popüler Ürünler"),
              const SizedBox(
                height: 10,
              ),
              LaptopUrunler()
            ],
          ),
        ),
      ),
    );
  }
}

class LaptopMarkalar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Markalar();
}

class _Markalar extends State<LaptopMarkalar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Markalar')
            .where(FieldPath.documentId, whereIn: [
          "asusrog",
          "monster",
          "msi",
          "hoACsUMA5y21E8ibQlNL",
          "iH26OlZicMnPoJfMtP81",
          "lzOJQ6x1JrCI3uTQuUN5"
        ]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.hasError}"),
            );
          }
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return Container(
            height: 65,
            width: 360,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: documents.map((document) {
                var markaId1 = document.id;
                var markaResim = document['markaImage'];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LaptopMarka(markaId1: markaId1)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 13.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.network(
                        markaResim,
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
        });
  }
}

class LaptopUrunler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Urunler();
}

class _Urunler extends State<LaptopUrunler> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Urunler')
            .where('tur', isEqualTo: 'laptop')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.hasError}"),
            );
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.5),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  var document = documents[index];
                  var laptopAd = document['adi'];
                  var laptopDeger = document['deger'];
                  var laptopImage = document['imageUrl1'];
                  var urunId = document.id;
                  var indirimliMi = document['indirimliMi'];
                  var indirimfiyat = document['indirimfiyat'];
                  var ortalamaPuan = document['ortalamaPuan'];
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(laptopImage),
                                      fit: BoxFit.fitWidth)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    laptopAd,
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
                                              "$indirimfiyat TL",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.orange),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              "$laptopDeger TL",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "$laptopDeger TL",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.orange),
                                        ),
                                ),
                              ],
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
                  );
                });
          }
        });
  }
}