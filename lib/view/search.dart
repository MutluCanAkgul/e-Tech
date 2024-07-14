import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/kategoriler/urundetay.dart';

class Arama extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AramaState();
}

class _AramaState extends State<Arama> {
  TextEditingController _arama = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _arama,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            hintText: "Ara...",
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.black),
            suffixIcon: IconButton(
              onPressed: () {
                // koşul eklenecek
              },
              icon: const Icon(Icons.search),
            ),
          ),
          style: const TextStyle(color: Colors.black, fontSize: 19),
        ),
      ),
      body: _arama.text.isEmpty
          ? const Center(
              child: Text('Lütfen bir arama yapın.'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Urunler').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final filtreliurun = snapshot.data!.docs.where((doc) {
                  final urunAdi = doc['adi'].toString().toLowerCase();
                  final aramaSorgu = _arama.text.toLowerCase();
                  return urunAdi.contains(aramaSorgu);
                }).toList();

                return ListView.builder(
                  itemCount: filtreliurun.length,
                  itemBuilder: (BuildContext context, int index) {
                    var document = filtreliurun[index];
                    var urunId = document.id;
                    var urunAdi = document['adi'];
                    var urunImageUrl = document['imageUrl1'];
                    var ortalamaPuan = document['ortalamaPuan'];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UrunDetay(urunId: urunId),
                            ),
                          );
                        },
                        leading: Image.network(
                          urunImageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          urunAdi,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            
                          ),
                        ),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [...List.generate(5, (index){
                            return Icon(index < ortalamaPuan ? Icons.star : Icons.star_border,color: Colors.amber,size: 20,);
                          }),
                          Text("(${ortalamaPuan})")],
                        ),
                        
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}