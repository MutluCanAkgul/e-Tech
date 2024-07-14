import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdresDuzenle extends StatefulWidget {
  final String adresId;
  final String sehir;
  final String ilce; 
  final String baslik;
  final String adres;
  final String telNo;

  AdresDuzenle({required this.adresId, required this.baslik, required this.sehir, required this.ilce, required this.adres, required this.telNo});
  
  @override
  State<StatefulWidget> createState() => _AdresDuzenle();
}

class _AdresDuzenle extends State<AdresDuzenle> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController adresBasligi;
  late TextEditingController adres;
  late TextEditingController telefonNum;

  String? seciliSehir;
  String? seciliIlce;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> sehirler = [];
  List<String> ilceler = [];

  @override
  void initState() {
    super.initState();
    adresBasligi = TextEditingController(text: widget.baslik);
    adres = TextEditingController(text: widget.adres);
    telefonNum = TextEditingController(text: widget.telNo);
    seciliSehir = widget.sehir;
    seciliIlce = widget.ilce;
    _getSehirler();
    _getIlceler(widget.sehir);
  }

  Future<void> _getSehirler() async {
    QuerySnapshot sehirlerSnapshot = await _firestore.collection('Sehirler').get();
    setState(() {
      sehirler = sehirlerSnapshot.docs.map((doc) => doc.id as String).toList();
    });
  }

  Future<void> _getIlceler(String sehir) async {
    DocumentSnapshot sehirDoc = await _firestore.collection('Sehirler').doc(sehir).get();
    if (sehirDoc.exists) {
      QuerySnapshot ilcelerSnapshot = await sehirDoc.reference.collection('ilceler').get();
      setState(() {
        ilceler = ilcelerSnapshot.docs.map((doc) => doc['adi'] as String).toList();
      });
    }
  }

  @override   
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adres Düzenle", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: adresBasligi,
                        decoration: const InputDecoration(labelText: "Adres Başlığı*", border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir adres başlığı giriniz.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: seciliSehir,
                        items: sehirler.map((sehir) {
                          return DropdownMenuItem<String>(
                            value: sehir,
                            child: Text(sehir),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            seciliSehir = value;
                            _getIlceler(value!);
                            seciliIlce = null;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Şehir*'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir şehir seçiniz.';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: seciliIlce,
                        items: ilceler.map((ilce) {
                          return DropdownMenuItem<String>(
                            value: ilce,
                            child: Text(ilce),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            seciliIlce = value;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'İlçe*'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir ilçe seçiniz.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {},
                        onInputValidated: (bool value) {},
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          useBottomSheetSafeArea: true,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: const TextStyle(color: Colors.black),
                        initialValue: PhoneNumber(isoCode: 'TR'),
                        textFieldController: telefonNum,
                        formatInput: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 13,
                        inputBorder: const OutlineInputBorder(),
                        onSaved: (PhoneNumber number) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        controller: adres,
                        decoration: const InputDecoration(hintText: "Adres*", border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen bir adres giriniz.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await _updateAddress(context);
                    }
                  },
                  child: Container(
                    height: 66,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Adresi Güncelle",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateAddress(BuildContext context) async {
    try {
      await _firestore.collection('Adresler').doc(widget.adresId).update({
        'baslik': adresBasligi.text,
        'sehir': seciliSehir,
        'ilce': seciliIlce,
        'adres': adres.text,
        'telNo': telefonNum.text,
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Başarılı"),
            content: const Text("Adres Başarıyla Güncellendi"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text("Tamam"),
              )
            ],
          );
        },
      );
    } catch (e) {
      print('Adres güncellenirken hata oluştu: $e');
    }
  }
}