import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/view/kategoriler/kategoriler.dart';
import 'package:flutter_application_1/view/kategoriler/markadetay.dart';
import 'package:flutter_application_1/view/kategoriler/urundetay.dart';
import 'package:flutter_application_1/view/panelview.dart';
import 'package:flutter_application_1/view/search.dart';
import 'package:flutter_application_1/view/usermenu/user.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Anasayfa extends StatefulWidget {
  final String? userName;

  const Anasayfa({Key? key, this.userName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Anasayfa();
}

class _Anasayfa extends State<Anasayfa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "E-Tech",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Arama()));
            },
            icon: const Icon(Icons.search, size: 20),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.white,
        color: Colors.orange,
        items: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Kategori()));
            },
            icon: const Icon(Icons.menu),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserUI()));
            },
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        "Hoşgeldin ${widget.userName?.isNotEmpty == true ? widget.userName! : 'Misafir'}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PageView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PanelView()));
                      },
                      child: Container(
                        child: Image.asset("images/panel1.png", fit: BoxFit.contain),
                      ),
                    ) 
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Markalar",
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
              const SizedBox(height: 5),
              Container(
                height: 100,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('Markalar').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Hata: ${snapshot.error}"));
                    }

                    final List<DocumentSnapshot> documents = snapshot.data!.docs;
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: documents.map((document) {
                        var markaId = document.id;
                        var imageUrl = document['markaImage'];
                        print('Marka Image URL: $imageUrl'); // Debug print
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
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return Icon(Icons.error); // Error handling
                                },
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "İndirimli Ürünler",
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
              const SizedBox(height: 5),
              Container(
                height: 300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Urunler')
                      .where('indirimliMi', isEqualTo: 1)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Hata: ${snapshot.error}"));
                    } else {
                      final List<DocumentSnapshot> documents = snapshot.data!.docs;
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: documents.map((document) {
                          var urunId = document.id;
                          var urunAd = document['adi'];
                          var indirimliFiyat = document['indirimfiyat'];
                          var urunFiyat = document['deger']; 
                          var ortalamaPuan = document['ortalamaPuan'];
                          String imageUrl = document['imageUrl1'];
                          print('Ürün Image URL: $imageUrl'); // Debug print
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UrunDetay(urunId: urunId),
                                ),
                              );
                            },
                            child: Container( decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Color.fromARGB(255, 203, 247, 255)),
                              margin: const EdgeInsets.only(right: 10.0),
                              width: 160, // Fixed width for consistent rendering
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height:170, // Fixed height for consistent rendering
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.fitHeight,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    urunAd,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
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
                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$indirimliFiyat TL",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "$urunFiyat TL",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 10, 10, 10),
                                            decoration: TextDecoration.lineThrough),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                 Container(
                                   decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                   child:const Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Center(
                                              child: Text(
                                                "Kargo Bedava",
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                 ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
