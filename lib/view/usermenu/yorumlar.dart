import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class YorumEkle extends StatefulWidget {
  final String urunId;

  YorumEkle({required this.urunId});

  @override
  State<StatefulWidget> createState() => _YorumEkle();
}

class _YorumEkle extends State<YorumEkle> {
  final TextEditingController _yorumController = TextEditingController();
  int _puan = 0;

  void _yorumEkle() async {
    final kulId = FirebaseAuth.instance.currentUser!.uid;
    final userDoc = await FirebaseFirestore.instance.collection('Kullanicilar').doc(kulId).get();
    final userData = userDoc.data();

    if (userData != null) {
      await FirebaseFirestore.instance.collection('Yorumlar').add({
        'urunId': widget.urunId,
        'kulId': kulId,
        'name': userData['name'],
        'surname': userData['surname'],
        'yorum': _yorumController.text,
        'puan': _puan,
      });

      // Yorum ekledikten sonra ortalama puanı güncelle
      _calculateAndUpdateAverageRating();

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kullanıcı bilgileri alınamadı. Lütfen tekrar deneyin.')),
      );
    }
  }
  void _calculateAndUpdateAverageRating() async {
  QuerySnapshot yorumlarSnapshot = await FirebaseFirestore.instance
      .collection('Yorumlar')
      .where('urunId', isEqualTo: widget.urunId)
      .get();

  double totalPuan = 0;
  int yorumSayisi = yorumlarSnapshot.docs.length;

  yorumlarSnapshot.docs.forEach((yorumDoc) {
    totalPuan += yorumDoc['puan'];
  });

  double ortalamaPuan = yorumSayisi > 0 ? totalPuan / yorumSayisi : 0;
  await FirebaseFirestore.instance.collection('Urunler').doc(widget.urunId).set({
    'ortalamaPuan': ortalamaPuan,
  }, SetOptions(merge: true));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yorum Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Puan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _puan ? Icons.star : Icons.star_border,
                  ),
                  color: Colors.amber,
                  onPressed: () {
                    setState(() {
                      _puan = index + 1;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _yorumController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Yorumunuzu yazın',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
           Row(
             children: [
               Expanded(
                 child: GestureDetector(
                  onTap: (){
                    _yorumEkle();
                  },
                  child: Container(height: 50,decoration: BoxDecoration(color: Colors.orange,borderRadius: BorderRadius.circular(16)),
                  child:const Center(child: Text("Yorum Yap",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),),
                 ),
               ),
             ],
           )
          ],
        ),
      ),
    );
  }
}
