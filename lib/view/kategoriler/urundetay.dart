import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/view/usermenu/yorumlar.dart';

class UrunDetay extends StatefulWidget {
  final String urunId;

  UrunDetay({required this.urunId});

  @override
  State<StatefulWidget> createState() => _UrunDetayState();
}

class _UrunDetayState extends State<UrunDetay> {
  late String kulId;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    kulId = FirebaseAuth.instance.currentUser!.uid;
    checkIfFavorite();
  }

  void checkIfFavorite() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Favori')
        .doc('$kulId-${widget.urunId}')
        .get();

    setState(() {
      isFavorite = doc.exists;
    });
  }

  void toggleFavorite() async {
    final favDoc = FirebaseFirestore.instance
        .collection('Favori')
        .doc('$kulId-${widget.urunId}');

    if (isFavorite) {
      await favDoc.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün favorilerden kaldırıldı.')),
      );
    } else {
      await favDoc.set({
        'urunId': widget.urunId,
        'kulId': kulId,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ürün başarıyla favorilere eklendi.')),
      );
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Urunler')
          .doc(widget.urunId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        var urunData = snapshot.data!.data() as Map<String, dynamic>;
        var indirimliMi = urunData['indirimliMi'];
        var deger = urunData['deger'];
        var indirimfiyat = urunData['indirimfiyat'];

        return Scaffold(
          appBar: AppBar(
            title: Text(
              urunData['adi'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      urunData['imageUrl1'] != ""
                          ? Image.network(urunData['imageUrl1'])
                          : Container(),
                      urunData['imageUrl2'] != ""
                          ? Image.network(urunData['imageUrl2'])
                          : Container(),
                      urunData['imageUrl3'] != ""
                          ? Image.network(urunData['imageUrl3'])
                          : Container(),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 234, 235, 236),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Özellikler",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 5,),
                          Text(
                            urunData['ozellikler'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                            StreamBuilder<QuerySnapshot>(
           stream: FirebaseFirestore.instance
             .collection('Yorumlar')
             .where('urunId', isEqualTo: widget.urunId)
             .snapshots(),
           builder: (context, snapshot) {
             if (!snapshot.hasData) {         
                return const Center(child: CircularProgressIndicator());
             }
             var yorumlar = snapshot.data!.docs;
             int yorumSayisi = yorumlar.length;
             double toplamPuan = 0;
                      yorumlar.forEach((yorum) {         
                 var yorumData = yorum.data() as Map<String, dynamic>;
                 toplamPuan += yorumData['puan'];
               });
             double ortalamaPuan = yorumSayisi > 0 ? toplamPuan / yorumSayisi : 0;
             int tamOrtalamaPuan = ortalamaPuan.round();
             return Row(              
               children: [
                 Text(         
                   "Yorumlar ($yorumSayisi)",
                   style: const TextStyle(
                     fontSize: 24,
                     fontWeight: FontWeight.w600,
                   ),
                 ),const SizedBox(width: 45),
                 GestureDetector(
                   onTap: () {
                     Navigator.push(         
                       context,
                       MaterialPageRoute(
                         builder: (context) => YorumEkle(urunId: widget.urunId),
                       ),
                     );
                   },
                   child: Row(
                     children: [
                       Row(
                         mainAxisSize: MainAxisSize.min,
                         children: List.generate(5, (index) {
                           return Icon(
                             index < tamOrtalamaPuan ? Icons.star : Icons.star_border,
                             color: Colors.amber,
                                      size: 22, 
                           );
                         }),
                       ),
                       const SizedBox(width: 5),
                       Text(
                         '($ortalamaPuan)',
                         style: const TextStyle(fontSize: 20),
                       ),
                     ],
                   ),
                 ),
               ],
             );
           },
         ),
        ],
      ),
      const SizedBox(height: 5,),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Yorumlar')
            .where('urunId', isEqualTo: widget.urunId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var yorumlar = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: yorumlar.length,
            itemBuilder: (context, index) {
              var yorumData = yorumlar[index].data() as Map<String, dynamic>;
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${yorumData['name']} ${yorumData['surname']}'),
                      const SizedBox(width: 5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < yorumData['puan'] ? Icons.star : Icons.star_border,
                            color: Colors.amber,size: 19,
                           );
                          }))]),
                           subtitle: Text(yorumData['yorum']),
                          ),
                          );
                           },
                         );
                       },
                     ),
                   ],
                 ),
               ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: const Color.fromARGB(255, 255, 153, 1),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding
                        : const EdgeInsets.symmetric(vertical: 1),
                        child: indirimliMi == 1
                            ? Column(
                                children: [
                                  Text(
                                    "$indirimfiyat TL",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "$deger TL",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "$deger TL",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: toggleFavorite,
                        child: Container(
                          height: 40,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            isFavorite ? "icons/heart1.png" : "icons/heart.png",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Sepete ekleme işlemi burada yapılacak
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          "Sepete Ekle",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
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
}
