import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/kategoriler/urundetay.dart';

class MarkaDetay extends StatefulWidget{
  final String markaId;
  const MarkaDetay({Key? key ,required this.markaId}) : super(key: key);
  @override
  State<StatefulWidget> createState()=> _UrunDetay();
}
class _UrunDetay extends State<MarkaDetay>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(actions: [IconButton(onPressed:(){}, icon:const Icon(Icons.shopping_basket))],
        title:const Text("Ürünler"),centerTitle: true,backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Urunler')
              .where('markaId', isEqualTo: widget.markaId).where('tur',isEqualTo:'telefon')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Hata: ${snapshot.error}"));
            } else {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return GridView.builder(
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
                  var urunId  = document.id;
                  var ortalamaPuan = document['ortalamaPuan'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UrunDetay(urunId:urunId),
                        ),
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
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    telefonAd,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
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
                                  child: Text(
                                    "$telefonDegeer TL",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text("   Kargo Bedava    "),
                                  ),
                                )
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
          },
        ),
      ),
    
    );
  
  
}
}