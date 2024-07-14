import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/view/kategoriler/urundetay.dart';

class MarkaDetay extends StatefulWidget {
  final String markaId;

  const MarkaDetay({Key? key, required this.markaId}) : super(key: key);

  @override
  _MarkaDetayState createState() => _MarkaDetayState();
}

class _MarkaDetayState extends State<MarkaDetay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Marka Ürünleri",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Urunler')
            .where('markaId', isEqualTo: widget.markaId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.6,
              ),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var document = documents[index];
                var urunAd = document['adi'];
                var urunDeger = document['deger'];
                var urunImage = document['imageUrl1'];
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
                                image: NetworkImage(urunImage),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                indirimliMi == 1
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$indirimFiyat TL",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.orange),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "$urunDeger TL",
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(255, 10, 10, 10),
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        "$urunDeger TL",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.orange),
                                      ),
                                const SizedBox(height: 5),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: const Text("   Kargo Bedava   "),
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}